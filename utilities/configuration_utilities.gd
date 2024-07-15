class_name ConfigurationUtilities
extends RefCounted



static var window : Window = null
var configuration : Configuration = null



func apply_window_size(new_size : Vector2i) -> void:
	configuration.window_size = new_size
	window.size = new_size

func apply_window_mode(new_mode : Window.Mode) -> void:
	configuration.window_mode = new_mode
	window.mode = new_mode

func apply_deep_mods_enabled(enabled : bool) -> void:
	configuration.deep_mods_enabled = enabled
