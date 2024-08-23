class_name BasicMain
extends SceneTree



#region

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_CRASH:
			Logger.loge("Game Crashed!")
			BasicGlobalRegistry.global_events.game_crashed.emit()



func _initialize() -> void:
	auto_accept_quit = false
	
	_load_modifications()
	
	_add_resource_savers_and_loaders()
	_connect_signals()
	_load_game_settings()
	_load_translations()
	
	ModsManagerUtilities.initialize_mods(BasicGlobalRegistry.mod_initializers)

#endregion



#region

func _add_resource_savers_and_loaders() -> void:
	ResourceLoader.add_resource_format_loader(BasicGameSettings.Loader.new())
	ResourceSaver.add_resource_format_saver(BasicGameSettings.Saver.new())
	ResourceLoader.add_resource_format_loader(BasicModification.Loader.new())
	ResourceLoader.add_resource_format_loader(TranslationUtilities.Loader.new())
	ResourceSaver.add_resource_format_saver(LogData.Saver.new())



func _connect_signals() -> void:
	BasicGlobalRegistry.global_events.mod_enabled.connect(ModsManagerUtilities.on_mod_enabled)
	BasicGlobalRegistry.global_events.mod_disabled.connect(ModsManagerUtilities.on_mod_disabled)
	BasicGlobalRegistry.global_events.mod_priority_changed.connect(ModsManagerUtilities.on_mod_priority_changed)



func _load_game_settings() -> void:
	var path : String = FilesystemUtilities.get_executable_directory() + BasicGameSettings.GAMESETTINGS_FILENAME
	BasicGlobalRegistry.game_settings = GameSettingsUtilities.load_game_settings_file(path)



func _load_modifications() -> void:
	ModsManagerUtilities.load_mods_settings()
	var path : String = FilesystemUtilities.get_executable_directory() + ModsManagerUtilities.MOD_DIRNAME
	ModsManagerUtilities.load_modifications(path)
	
	if not BasicGlobalRegistry.mods_settings.get_value(
		ModsManagerUtilities.SECTION_GLOBAL,
		ModsManagerUtilities.KEY_ENABLE_MODS,
		false):
		return
	
	ModsManagerUtilities.load_mods_files()



func _load_translations() -> void:
	TranslationUtilities.load_add_translation_dir(TranslationUtilities.TRANSLATION_DIR_PATH)

#endregion
