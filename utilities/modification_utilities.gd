class_name ModificationUtilities
extends RefCounted



# 深度修改模组：可以直接替换游戏源文件
# 浅度修改模组：无法替换游戏源文件，依赖API接口
enum ModificationType { DEEP_MOD, SHALLOW_MOD }

const DEEP_MOD_FILE_EXTENSION : PackedStringArray = [".pck", ".zip"]
const SHALLOW_MOD_FILE_EXTENSION : PackedStringArray = [".json"]
const INITIALIZER_SCRIPT_EXTENSION : PackedStringArray = [".gd"]
const METHOD_INITIALIZE : StringName = &"initialize"
const METHOD_READY : StringName = &"ready"
const MOD_INIT_DIR_PATH : StringName = &"res://modifications/__init/"



static var mod_initializers : Array[Object] = []



static func load_deep_modification(path : String, replace_files: bool = true) -> Error:
	var success : bool = ProjectSettings.load_resource_pack(path, replace_files)
	
	if not success:
		push_error("Failed to load deep modification: \"" + path + "\".")
		return FAILED
	
	return OK



static func load_deep_mods_from_dir(path : String, replace_files: bool = true) -> void:
	var files : PackedStringArray = FilesystemUtilities.get_files_from_dir(path)
	files = FilesystemUtilities.file_extension_filter(files, DEEP_MOD_FILE_EXTENSION)
	
	for file in files:
		load_deep_modification(file, replace_files)



static func load_mod_initializer(path : String) -> Object:
	var resource : Resource = load(path)
	if not resource is GDScript:
		push_error("The file (\"" + path + "\") must be a GDScript.")
		return null
	
	var script : GDScript = resource as GDScript
	if not script.can_instantiate():
		push_error("The initializer script (\"" + path + "\") must be able to be instantiated.")
		return null
	
	return script.new()



static func load_mod_initializers_from_dir(path : String) -> Array[Object]:
	var files : PackedStringArray = FilesystemUtilities.get_files_from_dir(path)
	files = FilesystemUtilities.file_extension_filter(files, INITIALIZER_SCRIPT_EXTENSION)
	
	var initializers : Array[Object] = []
	for file in files:
		var init : Object = load_mod_initializer(file)
		if is_instance_valid(init):
			initializers.append(init)
	
	return initializers



static func initialize_mod(initializer : Object, scene_tree : SceneTree = null) -> void:
	if initializer.has_method(METHOD_INITIALIZE) and not is_instance_valid(scene_tree):
		initializer.call(METHOD_INITIALIZE)
	if initializer.has_method(METHOD_READY) and is_instance_valid(scene_tree):
		initializer.call(METHOD_READY, scene_tree)



static func initialize_mods(initializers : Array[Object], scene_tree : SceneTree = null) -> void:
	for init in initializers:
		initialize_mod(init, scene_tree)



static func load_deep_mods(path : String) -> void:
	if not DirAccess.dir_exists_absolute(path):
		return
	
	load_deep_mods_from_dir(path)
	
	if not DirAccess.dir_exists_absolute(MOD_INIT_DIR_PATH):
		return
	
	var inits : Array[Object] = load_mod_initializers_from_dir(MOD_INIT_DIR_PATH)
	mod_initializers.append_array(inits)
