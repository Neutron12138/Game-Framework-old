class_name TranslationUtilities
extends RefCounted



const KEY_LOCALE : StringName = &"locale"
const KEY_MESSAGES : StringName = &"messages"
const KEY_CONTEXT : StringName = &"context"

const TRANSLATION_DIR_PATH : StringName = &"res://framework/translations/"
const TRANSLATION_FILE_EXTENSION : PackedStringArray = [".json"]



#region Loader

class Loader extends ResourceFormatLoader:
	func _get_recognized_extensions() -> PackedStringArray:
		return TRANSLATION_FILE_EXTENSION
	
	func _load(path: String, _original_path: String, _use_sub_threads: bool, _cache_mode: int) -> Variant:
		return TranslationUtilities.load_translation(path)

#endregion



#region tool functions

static func is_string_value(path : String, dict : Dictionary, key : String) -> bool:
	if not dict.has(key):
		Logger.loge("The translation file (\"%s\") is missing key: \"%s\"." % [path, key])
		return false
	if not dict[key] is String:
		Logger.loge("The key \"%s\" of the translation file (\"%s\") must be a String." % [key, path])
		return false
	return true



static func is_dictionary_value(path : String, dict : Dictionary, key : String) -> bool:
	if not dict.has(key):
		Logger.loge("The translation file (\"%s\") is missing key: \"%s\"." % [path, key])
		return false
	if not dict[key] is Dictionary:
		Logger.loge("The key \"%s\" of the translation file (\"%s\") must be a Dictionary." % [key, path])
		return false
	return true



static func is_valid_translation(path : String, dict : Dictionary) -> bool:
	if not is_string_value(path, dict, KEY_LOCALE):
		return false
	if not is_dictionary_value(path ,dict, KEY_MESSAGES):
		return false
	
	if dict.has(KEY_CONTEXT):
		if not (dict[KEY_CONTEXT] is String or dict[KEY_CONTEXT] is StringName):
			Logger.loge("The key \"%s\" of the translation file (\"%s\") must be a String/StringName." % [KEY_CONTEXT, path])
			return false
	
	return true

#endregion



#region loading functions

static func load_translation(path : String, skip_cr: bool = false) -> Translation:
	var dict : Dictionary = FilesystemUtilities.load_json_dictionary(path, skip_cr)
	if dict.is_empty():
		return null
	
	if not is_valid_translation(path, dict):
		return null
	
	var trans : Translation = Translation.new()
	trans.resource_path = path
	trans.locale = dict[KEY_LOCALE]
	
	var context : StringName = dict.get(KEY_CONTEXT, &"")
	
	var messages : Dictionary = dict[KEY_MESSAGES]
	for src in messages:
		var xlated : Variant = messages[src]
		trans.add_message(src, str(xlated), context)
	
	return trans



static func load_translations_from_dir(path : String, skip_cr: bool = false) -> Array[Translation]:
	var files : PackedStringArray = FilesystemUtilities.get_files_from_dir(path)
	files = FilesystemUtilities.file_extension_filter(files, TRANSLATION_FILE_EXTENSION)
	
	var result : Array[Translation] = []
	for file in files:
		var trans : Translation = load_translation(file, skip_cr)
		if is_instance_valid(trans):
			result.append(trans)
	return result

#endregion



#region adding functions

static func add_translation(trans : Translation) -> void:
	if is_instance_valid(trans):
		TranslationServer.add_translation(trans)
	else:
		Logger.loge("Invalid translation instance.")



static func add_translations(array : Array[Translation]) -> void:
	for i in range(array.size()):
		var trans : Translation = array[i]
		if is_instance_valid(trans):
			TranslationServer.add_translation(trans)
		else:
			Logger.loge("Invalid translation instance at index: %d." % i)

#endregion



static func load_add_translation(path : String, skip_cr: bool = false) -> void:
	var translation : Translation = load_translation(path, skip_cr)
	add_translation(translation)



static func load_add_translation_dir(path : String, skip_cr: bool = false) -> void:
	var translations : Array[Translation] = TranslationUtilities.load_translations_from_dir(path, skip_cr)
	TranslationUtilities.add_translations(translations)
