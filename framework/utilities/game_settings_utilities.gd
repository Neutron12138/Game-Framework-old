class_name GameSettingsUtilities
extends RefCounted



var scene_tree : SceneTree = null
var window : Window = null
var settings : BasicGameSettings = null



static func load_game_settings_file(path : String) -> BasicGameSettings:
	if not FileAccess.file_exists(path):
		BasicGameSettings.Saver.save(BasicGameSettings.new(), path)
		return BasicGameSettings.new()
	
	var result : BasicGameSettings = BasicGameSettings.Loader.load(path)
	if is_instance_valid(result):
		return result
	
	BasicGameSettings.Saver.save(BasicGameSettings.new(), path)
	return BasicGameSettings.new()



func _init(sets : BasicGameSettings, wnd : Window = Engine.get_main_loop().root) -> void:
	if not is_instance_valid(sets):
		Logger.loge("The GameSettings object instance cannot be a null pointer.")
		return
	if not is_instance_valid(wnd):
		Logger.loge("The window object instance cannot be a null pointer.")
		return
	
	settings = sets
	window = wnd
	scene_tree = Engine.get_main_loop()



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
	apply_language()

func apply_language() -> void:
	if not settings.language in BasicGlobalRegistry.supported_language:
		Logger.loge("This language is not supported: \"%s\"." % settings.language)
		return
	
	TranslationServer.set_locale(settings.language)
