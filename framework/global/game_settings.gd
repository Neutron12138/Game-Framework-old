class_name GameSettings
extends Resource



const GAMESETTINGS_FILE_EXTENSION : PackedStringArray = ["cfg"]
const GAMESETTINGS_FILENAME : StringName = "settings.cfg"



class Loader extends ResourceFormatLoader:
	func _get_recognized_extensions() -> PackedStringArray:
		return GAMESETTINGS_FILE_EXTENSION
	
	func _load(path: String, _original_path: String, _use_sub_threads: bool, _cache_mode: int) -> Variant:
		return Loader.load(path)
	
	static func load(path : String) -> GameSettings:
		var file : ConfigFile = ConfigFile.new()
		var err : Error = file.load(path)
		if err != OK:
			push_error("Failed to open configuration file (\"" + path +\
			"\"), reason: \"" + error_string(err) + "\".")
			return null
		
		var cfg : GameSettings = GameSettings.new()
		cfg.resource_path = path
		cfg.window_size = file.get_value(SECTION_WINDOW, KEY_WINDOW_SIZE, DEFAULT_WINDOW_SIZE)
		cfg.window_mode = file.get_value(SECTION_WINDOW, KEY_WINDOW_MODE, DEFAULT_WINDOW_MODE)
		cfg.enable_mods = file.get_value(SECTION_SYSTEM, KEY_ENABLE_MODS, DEFAULT_ENABLE_MODS)
		cfg.enable_debug_console = file.get_value(SECTION_SYSTEM, KEY_ENABLE_DEBUG_CONSOLE, DEFAULT_ENABLE_DEBUG_CONSOLE)
		cfg.pause_when_console = file.get_value(SECTION_SYSTEM, KEY_PAUSE_WHEN_CONSOLE, DEFAULT_PAUSE_WHEN_CONSOLE)
		cfg.enable_windowed_console = file.get_value(SECTION_SYSTEM, KEY_ENABLE_WINDOWED_CONSOLE, DEFAULT_ENABLE_WINDOWED_CONSOLE)
		
		return cfg



class Saver extends ResourceFormatSaver:
	func _get_recognized_extensions(_resource: Resource) -> PackedStringArray:
		return GAMESETTINGS_FILE_EXTENSION
	
	func _recognize(resource: Resource) -> bool:
		return resource is GameSettings
	
	func _save(resource: Resource, path: String, _flags: int) -> Error:
		return Saver.save(resource, path)
	
	static func save(resource: GameSettings, path: String) -> Error:
		var cfg : GameSettings = resource as GameSettings
		var file : ConfigFile = ConfigFile.new()
		
		file.set_value(SECTION_WINDOW, KEY_WINDOW_SIZE, cfg.window_size)
		file.set_value(SECTION_WINDOW, KEY_WINDOW_MODE, cfg.window_mode)
		file.set_value(SECTION_SYSTEM, KEY_ENABLE_MODS, cfg.enable_mods)
		file.set_value(SECTION_SYSTEM, KEY_ENABLE_DEBUG_CONSOLE, cfg.enable_debug_console)
		file.set_value(SECTION_SYSTEM, KEY_PAUSE_WHEN_CONSOLE, cfg.pause_when_console)
		file.set_value(SECTION_SYSTEM, KEY_ENABLE_WINDOWED_CONSOLE, cfg.enable_windowed_console)
		
		return file.save(path)



const SECTION_WINDOW : StringName = &"window"
const SECTION_SYSTEM : StringName = &"system"

const KEY_WINDOW_SIZE : StringName = &"window_size"
const KEY_WINDOW_MODE : StringName = &"window_mode"
const KEY_ENABLE_MODS : StringName = &"enable_mods"
const KEY_ENABLE_DEBUG_CONSOLE : StringName = &"enable_debug_console"
const KEY_PAUSE_WHEN_CONSOLE : StringName = &"pause_when_console"
const KEY_ENABLE_WINDOWED_CONSOLE : StringName = &"enable_windowed_console"

const DEFAULT_WINDOW_SIZE : Vector2i = Vector2i(1152, 648)
const DEFAULT_WINDOW_MODE : Window.Mode = Window.MODE_WINDOWED
const DEFAULT_ENABLE_MODS : bool = true
const DEFAULT_ENABLE_DEBUG_CONSOLE : bool = true
const DEFAULT_PAUSE_WHEN_CONSOLE : bool = false
const DEFAULT_ENABLE_WINDOWED_CONSOLE : bool = false



var window_size : Vector2i = DEFAULT_WINDOW_SIZE
var window_mode : Window.Mode = DEFAULT_WINDOW_MODE
var enable_mods : bool = DEFAULT_ENABLE_MODS
var enable_debug_console : bool = DEFAULT_ENABLE_DEBUG_CONSOLE
var pause_when_console : bool = DEFAULT_PAUSE_WHEN_CONSOLE
var enable_windowed_console : bool = DEFAULT_ENABLE_WINDOWED_CONSOLE



func _init(from : GameSettings = null, deep : bool = true) -> void:
	if not is_instance_valid(from):
		return
	
	window_size = from.window_size
	window_mode = from.window_mode
	enable_mods = from.enable_mods
	enable_debug_console = from.enable_debug_console
	pause_when_console = from.pause_when_console
	enable_windowed_console = from.enable_windowed_console



func _to_string() -> String:
	return str({
		KEY_WINDOW_SIZE : window_size,
		KEY_WINDOW_MODE : window_mode,
		KEY_ENABLE_MODS : enable_mods,
		KEY_ENABLE_DEBUG_CONSOLE : enable_debug_console,
		KEY_PAUSE_WHEN_CONSOLE : pause_when_console,
		KEY_ENABLE_WINDOWED_CONSOLE : enable_windowed_console
	})
