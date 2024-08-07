class_name FrameworkMain
extends SceneTree



static func _static_init() -> void:
	BasicGlobalRegistry.global_events = BasicGlobalEvents.new()



func _initialize() -> void:
	auto_accept_quit = false
	
	_add_resource_savers_and_loaders()
	_load_game_settings()
	_load_modifications()
	_load_translations()
	
	ModsManagerUtilities.initialize_mods(BasicGlobalRegistry.mod_initializers)



func _add_resource_savers_and_loaders() -> void:
	ResourceLoader.add_resource_format_loader(BasicGameSettings.Loader.new())
	ResourceSaver.add_resource_format_saver(BasicGameSettings.Saver.new())
	ResourceLoader.add_resource_format_loader(BasicModification.Loader.new())
	ResourceLoader.add_resource_format_loader(TranslationUtilities.Loader.new())
	ResourceSaver.add_resource_format_saver(LogData.Saver.new())



func _load_game_settings() -> void:
	BasicGlobalRegistry.game_settings = GameSettingsUtilities.load_game_settings_file(FilesystemUtilities.get_executable_directory() + BasicGameSettings.GAMESETTINGS_FILENAME)



func _load_modifications() -> void:
	if BasicGlobalRegistry.game_settings.enable_mods:
		ModsManagerUtilities.load_modifications(FilesystemUtilities.get_executable_directory() + ModsManagerUtilities.MOD_DIRNAME)



func _load_translations() -> void:
	TranslationUtilities.load_add_translation_dir(TranslationUtilities.TRANSLATION_DIR_PATH)
