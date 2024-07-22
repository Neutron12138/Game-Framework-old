class_name ModificationUtilities
extends RefCounted



const MOD_FILENAME : StringName = &"mod.json"

const METHOD_INITIALIZE : StringName = &"initialize"
const METHOD_READY : StringName = &"ready"



static var modifications : Array[Modification] = []
static var mod_initializers : Array[Object] = []



static func load_resource_pack(path : String, replace_files: bool = true) -> Error:
	var success : bool = ProjectSettings.load_resource_pack(path, replace_files)
	
	if not success:
		push_error("Failed to load resource pack: \"%s\"." % path)
		return FAILED
	
	return OK



static func load_mod_initializer(path : String) -> Object:
	var resource : Resource = load(path)
	if not resource is GDScript:
		push_error("The file (\"\") must be a GDScript." % path)
		return null
	
	var script : GDScript = resource as GDScript
	if not script.can_instantiate():
		push_error("The initializer script (\"\") must be able to be instantiated." % path)
		return null
	
	return script.new()



static func initialize_mod(initializer : Object, scene_tree : SceneTree = null) -> void:
	if initializer.has_method(METHOD_INITIALIZE) and not is_instance_valid(scene_tree):
		initializer.call(METHOD_INITIALIZE)
	if initializer.has_method(METHOD_READY) and is_instance_valid(scene_tree):
		initializer.call(METHOD_READY, scene_tree)



static func initialize_mods(initializers : Array[Object], scene_tree : SceneTree = null) -> void:
	for init in initializers:
		initialize_mod(init, scene_tree)



static func is_string_value(path : String, dict : Dictionary, key : String) -> bool:
	if not dict.has(key):
		push_error("The modification file (\"%s\") is missing key: \"%s\"." % [path, key])
		return false
	if not dict[key] is String:
		push_error("The key \"%s\" of the modification file (\"%s\") must be a String." % [key, path])
		return false
	return true



static func is_array_value(path : String, dict : Dictionary, key : String) -> bool:
	if not dict.has(key):
		push_error("The modification file (\"%s\") is missing key: \"%s\"." % [path, key])
		return false
	if not dict[key] is Array:
		push_error("The key \"%s\" of the modification file (\"%s\") must be an Array." % [key, path])
		return false
	return true



static func file_is_string_value(path : String, file : Dictionary, key : String, idx : int) -> bool:
	if not file.has(key):
		push_error("The file in modification (\"%s\") must has key: \"%s\", index: %d." % [path, key, idx])
		return false
	if not file[key] is String:
		push_error("The key \"%s\" in the file in modification (\"%s\") must be a String, index: %s." % [key, path, idx])
		return false
	return true



static func is_valid_file(path : String, file : Dictionary, idx : int) -> bool:
	if not file_is_string_value(path, file, Modification.KEY_PATH, idx):
		return false
	if not file_is_string_value(path, file, Modification.KEY_TYPE, idx):
		return false
	return true



static func is_valid_mod(path : String, dict : Dictionary) -> bool:
	if not is_string_value(path, dict, Modification.KEY_NAME):
		return false
	if not is_string_value(path, dict, Modification.KEY_AUTHOR):
		return false
	if not is_string_value(path, dict, Modification.KEY_VERSION):
		return false
	if not is_array_value(path, dict, Modification.KEY_FILES):
		return false
	
	var files : Array = dict[Modification.KEY_FILES]
	for i in range(files.size()):
		var file : Variant = files[i]
		if not file is Dictionary:
			push_error("The files in modification (\"%s\") must be a Dictionary, index: %d." % [path, i])
			return false
		
		if not is_valid_file(path, file, i):
			return false
	
	return true



static func load_mod_files(mod : Modification) -> void:
	var dir : String = mod.resource_path.get_base_dir() + "/"
	
	for file in mod.files:
		var path : String = FilesystemUtilities.analyse_path(file[Modification.KEY_PATH], dir)
		
		match file[Modification.KEY_TYPE]:
			Modification.TYPE_INITIALIZER:
				var obj : Object = load_mod_initializer(path)
				if not is_instance_valid(obj):
					continue
				mod_initializers.append(obj)
			
			Modification.TYPE_RESOURCE_PACK:
				load_resource_pack(path)



static func load_modification(path : String) -> void:
	var mod : Modification = Modification.Loader.load(path)
	if not is_instance_valid(mod):
		return
	
	modifications.append(mod)
	load_mod_files(mod)



static  func load_modifications(path : String) -> void:
	if not DirAccess.dir_exists_absolute(path):
		return
	
	var dirs : PackedStringArray = FilesystemUtilities.get_dirs_from_dir(path)
	for dir in dirs:
		var filename : String = dir + MOD_FILENAME
		if FileAccess.file_exists(filename):
			load_modification(filename)
