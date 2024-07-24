class_name GameData
extends Resource



const GAMEDATA_FILE_EXTENSION : PackedStringArray = ["json"]



class Loader extends ResourceFormatLoader:
	func _get_recognized_extensions() -> PackedStringArray:
		return GAMEDATA_FILE_EXTENSION
	
	func _load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int) -> Variant:
		return Loader.load(path)
	
	static func load(path : String) -> GameData:
		var data : GameData = GameData.new()
		data.data = FilesystemUtilities.load_json_dictionary(path)
		return data



class Saver extends ResourceFormatSaver:
	func _get_recognized_extensions(resource: Resource) -> PackedStringArray:
		return GAMEDATA_FILE_EXTENSION
	
	func _recognize(resource: Resource) -> bool:
		return resource is GameData
	
	func _save(resource: Resource, path: String, flags: int) -> Error:
		return Saver.save(resource, path)
	
	static func save(game_data : GameData, path : String) -> Error:
		var file : FileAccess = FilesystemUtilities.open_writeonly_file(path)
		if not is_instance_valid(file):
			return FAILED
		
		file.store_string(str(game_data.data))
		
		return OK



var data : Dictionary = {}



func _init(from : GameData = null, deep : bool = true) -> void:
	if not is_instance_valid(from):
		return
	
	data = from.data.duplicate(deep)
