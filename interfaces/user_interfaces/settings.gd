extends VBoxContainer



signal confirmed(current_tab : String)
signal canceled(current_tab : String)
signal applied(current_tab : String)



const WINDOW_MODE_ENUM : Dictionary = {
	"TEXT_FULLSCREEN" : Window.MODE_FULLSCREEN,
	"TEXT_WINDOWED" : Window.MODE_WINDOWED
}



@export var configuration : Configuration = null
var current_tab : String = Configuration.SECTION_WINDOW

@onready var window_settings : ScrollContainer = $window_settings
@onready var mods_settings : ScrollContainer = $mods_settings

@onready var window_size : HBoxContainer = $window_settings/VBoxContainer/window_size
@onready var window_mode : HBoxContainer = $window_settings/VBoxContainer/window_mode
@onready var deep_mods_enabled : HBoxContainer = $mods_settings/VBoxContainer/deep_mods_enabled



func reset() -> void:
	if not is_instance_valid(configuration):
		push_error("The configuration object instance cannot be a null pointer.")
		return
	
	window_size.x_edit.text = str(configuration.window_size.x)
	window_size.y_edit.text = str(configuration.window_size.y)
	
	window_mode.enum_items = WINDOW_MODE_ENUM
	window_mode.default_index = window_mode.get_index_by_value(configuration.window_mode)
	window_mode.reset()
	
	deep_mods_enabled.default_value = configuration.deep_mods_enabled
	deep_mods_enabled.reset()



func apply() -> void:
	match current_tab:
		Configuration.SECTION_WINDOW:
			configuration.window_size = window_size.get_value()
			configuration.window_mode = window_mode.get_value()
		Configuration.SECTION_MODS:
			configuration.deep_mods_enabled = deep_mods_enabled.get_value()



func _on_window_tab_pressed() -> void:
	current_tab = Configuration.SECTION_WINDOW
	if not window_settings.visible:
		window_settings.show()
	mods_settings.hide()


func _on_mods_tab_pressed() -> void:
	current_tab = Configuration.SECTION_MODS
	window_settings.hide()
	if not mods_settings.visible:
		mods_settings.show()


func _on_confirm_pressed() -> void:
	apply()
	emit_signal("confirmed", current_tab)


func _on_cancel_pressed() -> void:
	emit_signal("canceled", current_tab)


func _on_apply_pressed() -> void:
	apply()
	emit_signal("applied", current_tab)
