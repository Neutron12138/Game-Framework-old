class_name GameSettingsUtilities
extends RefCounted



static func load_game_settings_file(path : String) -> BasicGameSettings:
	if not FileAccess.file_exists(path):
		BasicGameSettings.Saver.save(BasicGameSettings.new(), path)
		return BasicGameSettings.new()
	
	var result : BasicGameSettings = BasicGameSettings.Loader.load(path)
	if is_instance_valid(result):
		return result
	
	result = BasicGameSettings.new()
	BasicGameSettings.Saver.save(result, path)
	return result



#region check

static func is_valid_settings(settings : BasicGameSettings) -> bool:
	if is_instance_valid(settings):
		return true
	
	Logger.loge("The GameSettings object instance cannot be a null pointer.")
	return false

static func is_valid_window(window : Window) -> bool:
	if is_instance_valid(window):
		return true
	
	Logger.loge("The window object instance cannot be a null pointer.")
	return false

static func is_valid(settings : BasicGameSettings, window : Window) -> bool:
	return is_valid_settings(settings) and is_valid_window(window)

#endregion



#region apply all

static func apply_all(settings : BasicGameSettings, window : Window) -> void:
	if not is_valid(settings, window):
		return
	
	_apply_window(settings, window)
	_apply_system(settings)



static func _apply_window(settings : BasicGameSettings, window : Window) -> void:
	_apply_window_size(settings, window)
	_apply_window_mode(settings, window)

static func apply_window(settings : BasicGameSettings, window : Window) -> void:
	if not is_valid(settings, window):
		return
	
	_apply_window(settings, window)



static func _apply_system(settings : BasicGameSettings) -> void:
	_apply_language(settings)

static func apply_system(settings : BasicGameSettings) -> void:
	if not is_valid_settings(settings):
		return
	
	_apply_system(settings)

#endregion



#region apply window

static func _apply_window_size(settings : BasicGameSettings, window : Window) -> void:
	window.size = settings.window_size

static func apply_window_size(settings : BasicGameSettings, window : Window) -> void:
	if not is_valid(settings, window):
		return
	
	_apply_window_size(settings, window)



static func _apply_window_mode(settings : BasicGameSettings, window : Window) -> void:
	window.mode = settings.window_mode

static func apply_window_mode(settings : BasicGameSettings, window : Window) -> void:
	if not is_valid(settings, window):
		return
	
	_apply_window_mode(settings, window)

#endregion



#region apply system

static func _apply_language(settings : BasicGameSettings) -> void:
	if not settings.language in BasicGlobalRegistry.supported_language:
		Logger.loge("This language is not supported: \"%s\"." % settings.language)
		return
	
	TranslationServer.set_locale(settings.language)

static func apply_language(settings : BasicGameSettings) -> void:
	if not is_valid_settings(settings):
		return
	
	_apply_language(settings)

#endregion
