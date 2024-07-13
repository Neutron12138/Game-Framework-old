class_name TranslationUtilities
extends Node



const KEY_LOCALE : StringName = &"locale"
const KEY_MESSAGES : StringName = &"messages"
const TRANSLATION_DIRECTORY_PATH : StringName = &"res://translations/"



static var error : Error = OK



static func load_translation(path : String, skip_cr: bool = false) -> Translation:
	var dict : Dictionary = FilesystemUtilities.load_json_dictionary(path, skip_cr)
	if FilesystemUtilities.error != OK:
		error = FAILED
		return null
	
	if not dict.has(KEY_LOCALE):
		push_error("Translation file (\"" + path + "\") is missing key: \"" +\
		KEY_LOCALE + "\".")
		error = ERR_PARSE_ERROR
		return null
	var locale : Variant = dict[KEY_LOCALE]
	if not locale is String:
		push_error("The key \"" + KEY_LOCALE +\
		"\" of the translation file (\"" + path +\
		"\") must be a String.")
		error = ERR_PARSE_ERROR
		return null
	
	if not dict.has(KEY_MESSAGES):
		push_error("Translation file (\"" + path + "\") is missing key: \"" +\
		KEY_MESSAGES + "\".")
		error = ERR_PARSE_ERROR
		return null
	var messages : Variant = dict[KEY_MESSAGES]
	if not messages is Dictionary:
		push_error("The key \"" + KEY_MESSAGES +\
		"\" of the translation file (\"" + path +\
		"\") must be a Dictionary.")
		error = ERR_PARSE_ERROR
		return null
	
	var trans : Translation = Translation.new()
	trans.locale = locale
	
	for src in messages:
		var xlated : Variant = messages[src]
		trans.add_message(src, str(xlated))
	
	return trans



static func load_translations_from_dir(path : String, skip_cr: bool = false) -> Array[Translation]:
	if not path.ends_with("/") or path.ends_with("\\"):
		path += "/"
	
	var dir : DirAccess = FilesystemUtilities.open_directory(path)
	if not is_instance_valid(dir):
		error = FAILED
		return []
	
	var result : Array[Translation] = []
	for file in dir.get_files():
		var trans : Translation = load_translation(path + file, skip_cr)
		if is_instance_valid(trans):
			result.append(trans)
	return result



static func add_translations(array : Array[Translation]) -> Error:
	for i in range(array.size()):
		var trans : Translation = array[i]
		if is_instance_valid(trans):
			TranslationServer.add_translation(trans)
		else:
			push_error("Invalid translation instance at index: " + str(i) + ".")
			return ERR_INVALID_PARAMETER
	return OK
