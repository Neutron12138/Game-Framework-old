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

@onready var window_settings : ScrollContainer = %window_settings
@onready var mods_settings : ScrollContainer = %mods_settings

@onready var window_size : HBoxContainer = %window_size
@onready var window_mode : HBoxContainer = %window_mode
@onready var enable_deep_mods : HBoxContainer = %enable_deep_mods



func reset() -> void:
	if not is_instance_valid(configuration):
		push_error("The configuration object instance cannot be a null pointer.")
		return
	
	window_size.value_x.text = str(configuration.window_size.x)
	window_size.value_y.text = str(configuration.window_size.y)
	
	window_mode.enum_items = WINDOW_MODE_ENUM
	window_mode.default_index = window_mode.get_index_by_value(configuration.window_mode)
	window_mode.reset()
	
	enable_deep_mods.default_value = configuration.enable_deep_mods
	enable_deep_mods.reset()



func apply() -> void:
	match current_tab:
		Configuration.SECTION_WINDOW:
			configuration.window_size = window_size.get_value()
			configuration.window_mode = window_mode.get_value()
		Configuration.SECTION_MODS:
			configuration.enable_deep_mods = enable_deep_mods.get_value()



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
