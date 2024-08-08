class_name BasicGlobalRegistry
extends RefCounted



static var global_data : Dictionary = {}
static var global_events : BasicGlobalEvents = null
static var game_settings : BasicGameSettings = null



static var modifications : Dictionary = {}
static var mod_initializers : Array[Object] = []
static var mods_settings : ConfigFile = null



static var supported_language : PackedStringArray = ["zh_CN", "en"]
static var language_enum : Dictionary = {
	TranslationServer.get_locale_name("zh_CN") : 0,
	TranslationServer.get_locale_name("en") : 1
}



static var supported_window_mode : PackedInt32Array = [Window.MODE_WINDOWED, Window.MODE_FULLSCREEN]
static var window_mode_enum : Dictionary = {
	"TEXT_WINDOWED" : Window.MODE_WINDOWED,
	"TEXT_FULLSCREEN" : Window.MODE_FULLSCREEN
}



static func _static_init() -> void:
	global_events = BasicGlobalEvents.new()
