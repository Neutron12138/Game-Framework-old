class_name LogData
extends Resource



const LOG_FILE_EXTENSION : PackedStringArray = ["log"]

const LEVEL_UNKNOWN : StringName = &"Unknown"
const LEVEL_DEBUG : StringName = &"Debug"
const LEVEL_INFO : StringName = &"Info"
const LEVEL_WARNING : StringName = &"Warning"
const LEVEL_ERROR : StringName = &"Error"



class LogItem extends RefCounted:
	var time : String = "%s %s" % [Time.get_date_string_from_system(), Time.get_time_string_from_system()]
	var level : StringName = LEVEL_UNKNOWN
	var message : String = ""
	
	func _init(msg : Variant, lv : StringName = LEVEL_UNKNOWN) -> void:
		level = lv
		message = str(msg)
	
	func _to_string() -> String:
		return "[%s][%s]%s" % [time, level, message]



class Saver extends ResourceFormatSaver:
	func _get_recognized_extensions(_resource: Resource) -> PackedStringArray:
		return LOG_FILE_EXTENSION
	
	func _recognize(resource: Resource) -> bool:
		return resource is LogData
	
	func _save(resource: Resource, path: String, _flags: int) -> Error:
		return Saver.save(resource, path)
	
	static func save(log_data : LogData, path : String) -> Error:
		var file : FileAccess = FilesystemUtilities.open_writeonly_file(path)
		if not is_instance_valid(file):
			return FAILED
		
		for item in log_data.log_items:
			file.store_line(str(item))
		
		return OK



var log_items : Array[LogItem] = []



func _init(from : LogData = null, deep : bool = true) -> void:
	if not is_instance_valid(from):
		return
	
	log_items = from.log_items.duplicate(deep)



func _to_string() -> String:
	return str(log_items)
