class_name BasicGameData
extends Resource



const GAMEDATA_FILE_EXTENSION : PackedStringArray = ["json"]



class Loader extends ResourceFormatLoader:
	func _get_recognized_extensions() -> PackedStringArray:
		return GAMEDATA_FILE_EXTENSION
	
	func _load(path: String, _original_path: String, _use_sub_threads: bool, _cache_mode: int) -> Variant:
		return Loader.load(path)
	
	static func load(path : String) -> BasicGameData:
		var data : BasicGameData = BasicGameData.new()
		data.resource_path = path
		data.data = FilesystemUtilities.load_json_dictionary(path)
		return data



class Saver extends ResourceFormatSaver:
	func _get_recognized_extensions(_resource: Resource) -> PackedStringArray:
		return GAMEDATA_FILE_EXTENSION
	
	func _recognize(resource: Resource) -> bool:
		return resource is BasicGameData
	
	func _save(resource: Resource, path: String, _flags: int) -> Error:
		return Saver.save(resource, path)
	
	static func save(game_data : BasicGameData, path : String) -> Error:
		var file : FileAccess = FilesystemUtilities.open_writeonly_file(path)
		if not is_instance_valid(file):
			return FAILED
		
		file.store_string(str(game_data.data))
		
		return OK



var data : Dictionary = {}



func _init(from : BasicGameData = null, deep : bool = true) -> void:
	if not is_instance_valid(from):
		return
	
	data = from.data.duplicate(deep)
