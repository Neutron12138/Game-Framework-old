class_name ConfigurationUtilities
extends RefCounted



static var window : Window = null
var configuration : Configuration = null



func _init(config : Configuration) -> void:
	if not is_instance_valid(window):
		push_error("The window object instance cannot be a null pointer.")
		return
	
	if not is_instance_valid(config):
		push_error("The configuration object instance cannot be a null pointer.")
		return
	
	configuration = config



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
	apply_deep_mods_enabled()

func apply_deep_mods_enabled() -> void:
	pass
