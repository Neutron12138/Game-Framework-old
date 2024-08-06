class_name ModificationUtilities
extends RefCounted



const MOD_FILENAME : StringName = &"mod.json"
const MOD_DIRNAME : StringName = &"mods/"

const METHOD_INITIALIZE : StringName = &"initialize"
const METHOD_READY : StringName = &"ready"



static func load_resource_pack(path : String, mod_path : String, replace_files: bool = true) -> Error:
	if not FileAccess.file_exists(path):
		Logger.loge("The file (\"%s\") in modification (\"%s\") does not exist." % [path, mod_path])
		return ERR_FILE_NOT_FOUND
	
	var success : bool = ProjectSettings.load_resource_pack(path, replace_files)
	
	if not success:
		Logger.loge("Failed to load resource pack: \"%s\"." % path)
		return FAILED
	
	return OK



static func load_mod_initializer(path : String, mod_path : String) -> Object:
	if not FileAccess.file_exists(path):
		Logger.loge("The file (\"%s\") in modification (\"%s\") does not exist." % [path, mod_path])
		return null
	
	var resource : Resource = load(path)
	if not resource is GDScript:
		Logger.loge("The file (\"%s\") must be a GDScript." % path)
		return null
	
	var script : GDScript = resource as GDScript
	if not script.can_instantiate():
		Logger.loge("The initializer script (\"%s\") must be able to be instantiated." % path)
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
		return true
	if not dict[key] is String:
		Logger.loge("The key \"%s\" of the modification file (\"%s\") must be a String." % [key, path])
		return false
	return true



static func is_array_value(path : String, dict : Dictionary, key : String) -> bool:
	if not dict.has(key):
		return true
	if not dict[key] is Array:
		Logger.loge("The key \"%s\" of the modification file (\"%s\") must be an Array." % [key, path])
		return false
	return true



static func file_is_string_value(path : String, file : Dictionary, key : String, idx : int) -> bool:
	if not file.has(key):
		Logger.loge("The file in modification (\"%s\") must has key: \"%s\", index: %d." % [path, key, idx])
		return false
	if not file[key] is String:
		Logger.loge("The key \"%s\" in the file in modification (\"%s\") must be a String, index: %s." % [key, path, idx])
		return false
	return true



static func is_valid_file(path : String, file : Dictionary, idx : int) -> bool:
	if not file_is_string_value(path, file, BasicModification.KEY_PATH, idx):
		return false
	if not file_is_string_value(path, file, BasicModification.KEY_TYPE, idx):
		return false
	return true



static func is_valid_mod(path : String, dict : Dictionary) -> bool:
	if not dict.has(BasicModification.KEY_IDENTITY):
		Logger.loge("The file in modification (\"%s\") must has key: \"%s\"." % [path, BasicModification.KEY_IDENTITY])
		return false
	
	if not is_string_value(path, dict, BasicModification.KEY_IDENTITY):
		return false
	if not is_string_value(path, dict, BasicModification.KEY_NAME):
		return false
	if not is_string_value(path, dict, BasicModification.KEY_ICON):
		return false
	if not is_string_value(path, dict, BasicModification.KEY_AUTHOR):
		return false
	if not is_string_value(path, dict, BasicModification.KEY_VERSION):
		return false
	if not is_array_value(path, dict, BasicModification.KEY_FILES):
		return false
	
	var files : Array = dict.get(BasicModification.KEY_FILES, [])
	for i in range(files.size()):
		var file : Variant = files[i]
		if not file is Dictionary:
			Logger.loge("The files in modification (\"%s\") must be a Dictionary, index: %d." % [path, i])
			return false
		
		if not is_valid_file(path, file, i):
			return false
	
	return true



static func load_mod_files(mod : BasicModification) -> void:
	for file in mod.files:
		var path : String = FilesystemUtilities.analyse_path(file[BasicModification.KEY_PATH], mod.directory)
		
		match file[BasicModification.KEY_TYPE]:
			BasicModification.TYPE_INITIALIZER:
				var obj : Object = load_mod_initializer(path, mod.resource_path)
				if not is_instance_valid(obj):
					continue
				BasicGlobalRegistry.mod_initializers.append(obj)
			
			BasicModification.TYPE_RESOURCE_PACK:
				var replace_files : bool = file.get(BasicModification.KEY_REPLACE_FILES, true)
				load_resource_pack(path, mod.resource_path, replace_files)
			
			BasicModification.TYPE_TRANSLATION:
				TranslationUtilities.load_add_translation(path)
			
			BasicModification.TYPE_TRANSLATION_DIR:
				TranslationUtilities.load_add_translation_dir(path)
			
			BasicModification.TYPE_OPTIONS:
				if not path.is_empty():
					mod.options = ResourceLoader.load(path)
					print(mod.options)



static func load_mods_settings() -> void:
	var path : String = FilesystemUtilities.get_executable_directory() + BasicModsSettings.MODSSETTINGS_FILENAME
	var settings : BasicModsSettings = BasicModsSettings.Loader.load(path)
	if is_instance_valid(settings):
		BasicGlobalRegistry.mods_settings = settings
	else:
		BasicGlobalRegistry.mods_settings = BasicModsSettings.new()



static func load_modification(path : String) -> void:
	var mod : BasicModification = BasicModification.Loader.load(path)
	if not is_instance_valid(mod):
		return
	
	if BasicGlobalRegistry.mods_settings.settings.has(mod.identity):
		var settings : BasicModsSettings.BasicSettings = BasicGlobalRegistry.mods_settings[mod.identity]
		if not settings.enable:
			return
	
	BasicGlobalRegistry.modifications[mod.identity] = mod
	BasicGlobalRegistry.mods_settings[mod.identity] = BasicModsSettings.BasicSettings.new()



static func load_modifications(path : String) -> void:
	if not DirAccess.dir_exists_absolute(path):
		return
	
	var dirs : PackedStringArray = FilesystemUtilities.get_dirs_from_dir(path)
	for dir in dirs:
		var filename : String = dir + MOD_FILENAME
		if FileAccess.file_exists(filename):
			load_modification(filename)
	
	var settings : Dictionary = BasicGlobalRegistry.mods_settings.settings:
	var priority : Dictionary = {}
