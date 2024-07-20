class_name Configuration
extends Resource



const CONFIGURATION_FILE_EXTENSION : PackedStringArray = ["cfg"]
const CONFIGURATION_FILENAME : StringName = "configs.cfg"



class Loader extends ResourceFormatLoader:
	func _get_recognized_extensions() -> PackedStringArray:
		return CONFIGURATION_FILE_EXTENSION
	
	func _load(path: String, _original_path: String, _use_sub_threads: bool, _cache_mode: int) -> Variant:
		var file : ConfigFile = ConfigFile.new()
		var err : Error = file.load(path)
		if err != OK:
			push_error("Failed to open configuration file (\"" + path +\
			"\"), reason: \"" + error_string(err) + "\".")
			return null
		
		var cfg : Configuration = Configuration.new()
		cfg.window_size = file.get_value(SECTION_WINDOW, KEY_WINDOW_SIZE, DEFAULT_WINDOW_SIZE)
		cfg.window_mode = file.get_value(SECTION_WINDOW, KEY_WINDOW_MODE, DEFAULT_WINDOW_MODE)
		cfg.enable_deep_mods = file.get_value(SECTION_MODS, KEY_ENABLE_DEEP_MODS, DEFAULT_ENABLE_DEEP_MODS)
		
		return cfg



class Saver extends ResourceFormatSaver:
	func _get_recognized_extensions(_resource: Resource) -> PackedStringArray:
		return CONFIGURATION_FILE_EXTENSION
	
	func _recognize(resource: Resource) -> bool:
		return resource is Configuration
	
	func _save(resource: Resource, path: String, _flags: int) -> Error:
		var cfg : Configuration = resource as Configuration
		var file : ConfigFile = ConfigFile.new()
		
		file.set_value(SECTION_WINDOW, KEY_WINDOW_SIZE, cfg.window_size)
		file.set_value(SECTION_WINDOW, KEY_WINDOW_MODE, cfg.window_mode)
		file.set_value(SECTION_MODS, KEY_ENABLE_DEEP_MODS, cfg.enable_deep_mods)
		
		return file.save(path)



const SECTION_WINDOW : StringName = &"window"
const SECTION_MODS : StringName = &"mods"

const KEY_WINDOW_SIZE : StringName = &"window_size"
const KEY_WINDOW_MODE : StringName = &"window_mode"
const KEY_ENABLE_DEEP_MODS : StringName = &"enable_deep_mods"

const DEFAULT_WINDOW_SIZE : Vector2i = Vector2i(1152, 648)
const DEFAULT_WINDOW_MODE : Window.Mode = Window.MODE_WINDOWED
const DEFAULT_ENABLE_DEEP_MODS : bool = true



var window_size : Vector2i = DEFAULT_WINDOW_SIZE
var window_mode : Window.Mode = DEFAULT_WINDOW_MODE
var enable_deep_mods : bool = DEFAULT_ENABLE_DEEP_MODS



func _init(from : Configuration = null) -> void:
	if not is_instance_valid(from):
		return
	
	window_size = from.window_size
	window_mode = from.window_mode
	enable_deep_mods = from.enable_deep_mods



func _to_string() -> String:
	return str({
		KEY_WINDOW_SIZE : window_size,
		KEY_WINDOW_MODE : window_mode,
		KEY_ENABLE_DEEP_MODS : enable_deep_mods
	})
