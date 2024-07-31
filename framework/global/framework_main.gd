class_name FrameworkMain
extends SceneTree



static var global_data : Dictionary = {}
static var global_events : GlobalEvents = null
var game_settings : GameSettings = null



static func _static_init() -> void:
	global_events = GlobalEvents.new()



func _initialize() -> void:
	auto_accept_quit = false
	
	_add_resource_savers_and_loaders()
	_load_game_settings()
	_load_modifications()
	_load_translations()
	
	ModificationUtilities.initialize_mods(ModificationUtilities.mod_initializers)



func _add_resource_savers_and_loaders() -> void:
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
	TranslationUtilities.load_add_translation_dir(TranslationUtilities.TRANSLATION_DIR_PATH)
