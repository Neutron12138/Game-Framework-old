extends VBoxContainer



signal confirmed(current_tab : String)
signal canceled(current_tab : String)
signal applied(current_tab : String)



@export var settings : BasicGameSettings = null
var current_tab : String = BasicGameSettings.SECTION_WINDOW

@onready var window_settings : ScrollContainer = %window_settings
@onready var system_settings : ScrollContainer = %system_settings

@onready var window_size : HBoxContainer = %window_size
@onready var window_mode : HBoxContainer = %window_mode
@onready var enable_debug_console : HBoxContainer = %enable_debug_console
@onready var pause_when_console : HBoxContainer = %pause_when_console
@onready var language : HBoxContainer = %language



func reset() -> void:
	if not is_instance_valid(settings):
		push_error("The configuration object instance cannot be a null pointer.")
		return
	
	window_size.default_value_x = str(settings.window_size.x)
	window_size.default_value_y = str(settings.window_size.y)
	window_size.reset()
	
	window_mode.enum_items = BasicGlobalRegistry.window_mode_enum
	window_mode.default_index = window_mode.get_index_by_value(settings.window_mode)
	window_mode.reset()
	
	enable_debug_console.default_value = settings.enable_debug_console
	enable_debug_console.reset()
	
	pause_when_console.default_value = settings.pause_when_console
	pause_when_console.reset()
	
	language.enum_items = BasicGlobalRegistry.language_enum
	language.default_index = BasicGlobalRegistry.supported_language.find(settings.language)
	language.reset()



func apply() -> void:
	match current_tab:
		BasicGameSettings.SECTION_WINDOW:
			var wnd_size : Variant = window_size.get_value()
			if wnd_size is Vector2 or wnd_size is Vector2i:
				settings.window_size = wnd_size
			
			var mode : Variant = window_mode.get_value()
			if not mode is int:
				settings.window_mode = Window.MODE_WINDOWED
			elif mode in BasicGlobalRegistry.supported_window_mode:
				settings.window_mode = mode
			else:
				settings.window_mode = Window.MODE_WINDOWED
		
		BasicGameSettings.SECTION_SYSTEM:
			settings.enable_debug_console = enable_debug_console.get_value()
			settings.pause_when_console = pause_when_console.get_value()
			
			var lang_idx : Variant = language.get_value()
			if not lang_idx is int:
				settings.language = TranslationServer.get_locale()
			elif lang_idx in range(BasicGlobalRegistry.supported_language.size()):
				settings.language = BasicGlobalRegistry.supported_language[lang_idx]
			else:
				settings.language = TranslationServer.get_locale()



func _on_confirm_pressed() -> void:
	apply()
	confirmed.emit(current_tab)


func _on_cancel_pressed() -> void:
	canceled.emit(current_tab)


func _on_apply_pressed() -> void:
	apply()
	applied.emit(current_tab)


func _on_window_tab_pressed() -> void:
	current_tab = BasicGameSettings.SECTION_WINDOW
	window_settings.show()
	system_settings.hide()


func _on_system_tab_pressed() -> void:
	current_tab = BasicGameSettings.SECTION_SYSTEM
	window_settings.hide()
	system_settings.show()
