class_name Logger
extends RefCounted



const LOG_FILENAME : StringName = &"log.log"



static var log_data : LogData = LogData.new()
static var auto_save : bool = true
static var auto_print : bool = true



static func save() -> void:
	LogData.Saver.save(log_data, LOG_FILENAME)



static func log(message : String, level : LogData.Level = LogData.Level.UNKNOWN) -> void:
	log_data.log_items.append(LogData.LogItem.new(message, level))
	
	if auto_save:
		save()



static func logu(message : String) -> void:
	Logger.log(message, LogData.Level.UNKNOWN)
	
	if auto_print:
		print(message)



static func logd(message : String) -> void:
	Logger.log(message, LogData.Level.DEBUG)
	
	if auto_print:
		print_debug(message)



static func logi(message : String) -> void:
	Logger.log(message, LogData.Level.INFO)
	
	if auto_print:
		print(message)



static func logw(message : String) -> void:
	Logger.log(message, LogData.Level.WARNING)
	
	if auto_print:
		push_warning(message)



static func loge(message : String) -> void:
	Logger.log(message, LogData.Level.ERROR)
	
	if auto_print:
		push_error(message)
