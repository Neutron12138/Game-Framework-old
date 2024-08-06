class_name BasicModification
extends Resource



const MOD_CONFIG_FILE_EXTENSION : PackedStringArray = ["json"]

const KEY_IDENTITY : StringName = &"identity"
const KEY_ENABLE : StringName = &"enable"
const KEY_PRIORITY : StringName = &"priority"
const KEY_NAME : StringName = &"name"
const KEY_ICON : StringName = &"icon"
const KEY_AUTHOR : StringName = &"author"
const KEY_VERSION : StringName = &"version"
const KEY_FILES : StringName = &"files"
const KEY_PATH : StringName = &"path"
const KEY_TYPE : StringName = &"type"
const KEY_REPLACE_FILES : StringName = &"replace_files"

const TYPE_INITIALIZER : StringName = &"initializer"
const TYPE_RESOURCE_PACK : StringName = &"resource_pack"
const TYPE_TRANSLATION : StringName = &"translation"
const TYPE_TRANSLATION_DIR : StringName = &"translation_dir"
const TYPE_OPTIONS : StringName = &"options"



class Loader extends ResourceFormatLoader:
	func _get_recognized_extensions() -> PackedStringArray:
		return MOD_CONFIG_FILE_EXTENSION
	
	func _load(path: String, _original_path: String, _use_sub_threads: bool, _cache_mode: int) -> Variant:
		return Loader.load(path)
	
	static func load(path : String) -> BasicModification:
		var dict : Dictionary = FilesystemUtilities.load_json_dictionary(path)
		if dict.is_empty():
			return null
		
		if not ModificationUtilities.is_valid_mod(path, dict):
			return null
		
		var mod : BasicModification = BasicModification.new()
		mod.resource_path = path
		mod.identity = dict.get(KEY_IDENTITY)
		mod.enable = dict.get(KEY_ENABLE, false)
		mod.priority = dict.get(KEY_PRIORITY, 0)
		mod.name = dict.get(KEY_NAME, "")
		mod.icon = dict.get(KEY_ICON, "")
		mod.author = dict.get(KEY_AUTHOR, "")
		mod.version = dict.get(KEY_VERSION, "")
		mod.directory = path.get_base_dir() + "/"
		mod.files = dict.get(KEY_FILES, [])
		
		return mod



var identity : StringName = &""
var enable : bool = false
var priority : int = 0
var name : String = ""
var icon : String = ""
var author : String = ""
var version : String = ""
var directory : String = ""
var options : PackedScene = null
var files : Array = []



func _init(from : BasicModification = null, deep : bool = false) -> void:
	if not is_instance_valid(from):
		return
	
	identity = from.identity
	enable = from.enable
	priority = from.priority
	name = from.name
	icon = from.icon
	author = from.author
	version = from.version
	directory = from.directory
	files = from.files.duplicate(deep)
