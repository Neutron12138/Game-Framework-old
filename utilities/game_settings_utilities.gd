class_name GameSettingsUtilities
extends RefCounted



var window : Window = null
var settings : GameSettings = null



static func load_configuration_file(path : String) -> GameSettings:
	if not FileAccess.file_exists(path):
		return GameSettings.new()
	
	var result : GameSettings = load(path) as GameSettings
	if is_instance_valid(result):
		return result
	
	return GameSettings.new()



func _init(sets : GameSettings, wnd : Window = Engine.get_main_loop().root) -> void:
	if not is_instance_valid(sets):
		push_error("The GameSettings object instance cannot be a null pointer.")
		return
	if not is_instance_valid(wnd):
		push_error("The window object instance cannot be a null pointer.")
		return
	
	settings = sets
	window = wnd



func apply_all() -> void:
	apply_window()
	apply_system()



func apply_window() -> void:
	apply_window_size()
	apply_window_mode()

func apply_window_size() -> void:
	window.size = settings.window_size

func apply_window_mode() -> void:
	window.mode = settings.window_mode



func apply_system() -> void:
	pass
