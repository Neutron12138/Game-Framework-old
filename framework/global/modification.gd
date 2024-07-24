class_name Modification
extends Resource



const MOD_CONFIG_FILE_EXTENSION : PackedStringArray = ["json"]

const KEY_NAME : StringName = &"name"
const KEY_AUTHOR : StringName = &"author"
const KEY_VERSION : StringName = &"version"
const KEY_FILES : StringName = &"files"
const KEY_PATH : StringName = &"path"
const KEY_TYPE : StringName = &"type"

const TYPE_INITIALIZER : StringName = &"initializer"
const TYPE_RESOURCE_PACK : StringName = &"resource_pack"



class Loader extends ResourceFormatLoader:
	func _get_recognized_extensions() -> PackedStringArray:
		return MOD_CONFIG_FILE_EXTENSION
	
	func _load(path: String, _original_path: String, _use_sub_threads: bool, _cache_mode: int) -> Variant:
		return Loader.load(path)
	
	static func load(path : String) -> Modification:
		var dict : Dictionary = FilesystemUtilities.load_json_dictionary(path)
		if dict.is_empty():
			return null
		
		if not ModificationUtilities.is_valid_mod(path, dict):
			return null
		
		var mod : Modification = Modification.new()
		mod.resource_path = path
		mod.name = dict.get(KEY_NAME)
		mod.author = dict.get(KEY_AUTHOR)
		mod.version = dict.get(KEY_VERSION)
		mod.files = dict.get(KEY_FILES)
		
		return mod



var name : String = ""
var author : String = ""
var version : String = ""
var files : Array = []



func _init(from : Modification = null, deep : bool = false) -> void:
	if not is_instance_valid(from):
		return
	
	name = from.name
	author = from.author
	version = from.version
	files = from.files.duplicate(deep)
