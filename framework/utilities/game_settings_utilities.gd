class_name GameSettingsUtilities
extends RefCounted



var scene_tree : SceneTree = null
var window : Window = null
var settings : GameSettings = null



static func load_game_settings_file(path : String) -> GameSettings:
	if not FileAccess.file_exists(path):
		GameSettings.Saver.save(GameSettings.new(), path)
		return GameSettings.new()
	
	var result : GameSettings = GameSettings.Loader.load(path)
	if is_instance_valid(result):
		return result
	
	GameSettings.Saver.save(GameSettings.new(), path)
	return GameSettings.new()



func _init(sets : GameSettings, wnd : Window = Engine.get_main_loop().root) -> void:
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
	pass
