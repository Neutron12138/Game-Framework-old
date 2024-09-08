class_name ModFileChecker
extends RefCounted



#region utilities

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

#endregion



#region check

static func check_identity(mod : BasicModification) -> bool:
	if not is_string_value(path, dict, BasicModification.KEY_IDENTITY):
		return false
	var identity : String = dict.get(BasicModification.KEY_IDENTITY)
	if identity == ModsManager.SECTION_GLOBAL or not identity.is_valid_identifier():
		Logger.loge("The \"%s\" attribute of the modification (\"%s\") is an invalid identifier." % [BasicModification.KEY_IDENTITY, path])
		return false
	
	return true

#endregion



static func check_mod(path : String, dict : Dictionary) -> bool:
	
	
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
