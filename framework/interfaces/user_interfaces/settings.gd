extends VBoxContainer



signal confirmed(current_tab : String)
signal canceled(current_tab : String)
signal applied(current_tab : String)



const WINDOW_MODE_ENUM : Dictionary = {
	"TEXT_FULLSCREEN" : Window.MODE_FULLSCREEN,
	"TEXT_WINDOWED" : Window.MODE_WINDOWED
}



@export var settings : GameSettings = null
var current_tab : String = GameSettings.SECTION_WINDOW

@onready var window_settings : ScrollContainer = %window_settings
@onready var system_settings : ScrollContainer = %system_settings

@onready var window_size : HBoxContainer = %window_size
@onready var window_mode : HBoxContainer = %window_mode
@onready var enable_mods : HBoxContainer = %enable_mods
@onready var enable_debug_console : HBoxContainer = %enable_debug_console
@onready var pause_when_console : HBoxContainer = %pause_when_console
@onready var enable_windowed_console : HBoxContainer = %enable_windowed_console



func reset() -> void:
	if not is_instance_valid(settings):
		push_error("The configuration object instance cannot be a null pointer.")
		return
	
	window_size.default_value_x = str(settings.window_size.x)
	window_size.default_value_y = str(settings.window_size.y)
	window_size.reset()
	
	window_mode.enum_items = WINDOW_MODE_ENUM
	window_mode.default_index = window_mode.get_index_by_value(settings.window_mode)
	window_mode.reset()
	
	enable_mods.default_value = settings.enable_mods
	enable_mods.reset()
	
	enable_debug_console.default_value = settings.enable_debug_console
	enable_debug_console.reset()
	
	pause_when_console.default_value = settings.pause_when_console
	pause_when_console.reset()
	
	enable_windowed_console.default_value = settings.enable_windowed_console
	%enable_windowed_console/value.disabled = true
	enable_windowed_console.reset()



func apply() -> void:
	match current_tab:
		GameSettings.SECTION_WINDOW:
			settings.window_size = window_size.get_value()
			settings.window_mode = window_mode.get_value()
		GameSettings.SECTION_SYSTEM:
			settings.enable_mods = enable_mods.get_value()
			settings.enable_debug_console = enable_debug_console.get_value()
			settings.pause_when_console = pause_when_console.get_value()
			settings.enable_windowed_console = enable_windowed_console.get_value()



func _on_confirm_pressed() -> void:
	apply()
	emit_signal("confirmed", current_tab)


func _on_cancel_pressed() -> void:
	emit_signal("canceled", current_tab)


func _on_apply_pressed() -> void:
	apply()
	emit_signal("applied", current_tab)


func _on_window_tab_pressed() -> void:
	current_tab = GameSettings.SECTION_WINDOW
	window_settings.show()
	system_settings.hide()


func _on_system_tab_pressed() -> void:
	current_tab = GameSettings.SECTION_SYSTEM
	window_settings.hide()
	system_settings.show()
