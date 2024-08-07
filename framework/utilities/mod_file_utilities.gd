class_name ModFileUtilities
extends RefCounted



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
	
	var script : GDScript = resource
	if not script.can_instantiate():
		Logger.loge("The initializer script (\"%s\") must be able to be instantiated." % path)
		return null
	
	return script.new()



static func load_mod_files(mod : BasicModification) -> void:
	for i in range(mod.files.size()):
		var file : Dictionary = mod.files[i]
		var path : String = FilesystemUtilities.analyse_path(file[BasicModification.KEY_PATH], mod.directory)
		var type : StringName = file[BasicModification.KEY_TYPE]
		
		if path.is_empty():
			Logger.loge("The file path is empty and cannot be loaded, in the modification (\"%s\"), index: %d." % [path, i])
			continue
		
		match type:
			BasicModification.TYPE_INITIALIZER:
				var obj : Object = load_mod_initializer(path, mod.resource_path)
				if is_instance_valid(obj):
					BasicGlobalRegistry.mod_initializers.append(obj)
			
			BasicModification.TYPE_RESOURCE_PACK:
				var replace_files : bool = file.get(BasicModification.KEY_REPLACE_FILES, true)
				load_resource_pack(path, mod.resource_path, replace_files)
			
			BasicModification.TYPE_TRANSLATION:
				TranslationUtilities.load_add_translation(path)
			
			BasicModification.TYPE_TRANSLATION_DIR:
				TranslationUtilities.load_add_translation_dir(path)
			
			_:
				Logger.loge("Unknown file type (\"%s\") at index %d of files in modification (\"%s\")." % [type, i, mod.resource_path])
