class_name ConfigurationUtilities
extends RefCounted



var window : Window = null
var configuration : Configuration = null



static func load_configuration_file(path : String) -> Configuration:
	if not FileAccess.file_exists(path):
		return Configuration.new()
	
	var config : Configuration = load(path) as Configuration
	if is_instance_valid(config):
		return config
	
	return Configuration.new()



func _init(cfg : Configuration, wnd : Window = Engine.get_main_loop().root) -> void:
	if not is_instance_valid(cfg):
		push_error("The configuration object instance cannot be a null pointer.")
		return
	if not is_instance_valid(wnd):
		push_error("The window object instance cannot be a null pointer.")
		return
	
	configuration = cfg
	window = wnd



func apply_all() -> void:
	apply_window()
	apply_mods()



func apply_window() -> void:
	apply_window_size()
	apply_window_mode()

func apply_window_size() -> void:
	window.size = configuration.window_size

func apply_window_mode() -> void:
	window.mode = configuration.window_mode



func apply_mods() -> void:
	apply_enable_deep_mods()

func apply_enable_deep_mods() -> void:
	pass
