class_name Main
extends SceneTree



static var global_data : Dictionary = {}
var game_settings : GameSettings = null



func _initialize() -> void:
	_load_resource_savers_and_loaders()
	_load_game_settings()
	_load_modifications()
	_load_translations()
	auto_accept_quit = false
	
	ModificationUtilities.initialize_mods(ModificationUtilities.mod_initializers)



func _load_resource_savers_and_loaders() -> void:
	ResourceLoader.add_resource_format_loader(GameSettings.Loader.new())
	ResourceSaver.add_resource_format_saver(GameSettings.Saver.new())
	ResourceLoader.add_resource_format_loader(Modification.Loader.new())
	ResourceLoader.add_resource_format_loader(TranslationUtilities.Loader.new())
	ResourceSaver.add_resource_format_saver(LogData.Saver.new())



func _load_game_settings() -> void:
	game_settings = GameSettingsUtilities.load_game_settings_file(FilesystemUtilities.get_executable_directory() + GameSettings.GAMESETTINGS_FILENAME)



func _load_modifications() -> void:
	if game_settings.enable_mods:
		ModificationUtilities.load_modifications(FilesystemUtilities.get_executable_directory() + ModificationUtilities.MOD_DIRNAME)



func _load_translations() -> void:
	TranslationUtilities.load_translations(TranslationUtilities.TRANSLATION_DIR_PATH)
