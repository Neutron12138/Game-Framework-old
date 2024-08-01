class_name Logger
extends RefCounted



const LOG_FILENAME : StringName = &"log.log"



static var log_data : LogData = LogData.new()
static var file : FileAccess = null
static var auto_save : bool = true
static var auto_print : bool = true



static func _static_init() -> void:
	file = FilesystemUtilities.open_writeonly_file(FilesystemUtilities.get_executable_directory() + LOG_FILENAME)



static func update() -> void:
	file.flush()



static func log(message : String, level : StringName = LogData.LEVEL_UNKNOWN) -> void:
	log_data.log_items.append(LogData.LogItem.new(message, level))
	
	if auto_save:
		update()
	
	if not auto_print:
		return
	
	match level:
		LogData.LEVEL_DEBUG:
			print(message)
			print_stack()
		
		LogData.LEVEL_WARNING:
			push_warning(message)
		
		LogData.LEVEL_ERROR:
			push_error(message)
		
		_:
			print(message)



static func logu(message : String) -> void:
	Logger.log(message, LogData.LEVEL_UNKNOWN)

static func logd(message : String) -> void:
	Logger.log(message, LogData.LEVEL_DEBUG)

static func logi(message : String) -> void:
	Logger.log(message, LogData.LEVEL_INFO)

static func logw(message : String) -> void:
	Logger.log(message, LogData.LEVEL_WARNING)

static func loge(message : String) -> void:
	Logger.log(message, LogData.LEVEL_ERROR)
