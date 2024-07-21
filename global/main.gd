class_name Main
extends SceneTree



static var global_data : Dictionary = {}
var game_settings : GameSettings = null
var debug_console : Node = null



func _initialize() -> void:
	_load_configuration()
	_load_modifications()
	_load_translations()
	auto_accept_quit = false
	
	ModificationUtilities.initialize_mods(ModificationUtilities.mod_initializers)



func _load_configuration() -> void:
	ResourceLoader.add_resource_format_loader(GameSettings.Loader.new())
	ResourceSaver.add_resource_format_saver(GameSettings.Saver.new())
	game_settings = GameSettingsUtilities.load_configuration_file(FilesystemUtilities.get_executable_directory() + GameSettings.CONFIGURATION_FILENAME)



func _load_modifications() -> void:
	if game_settings.enable_deep_mods:
		ModificationUtilities.load_deep_mods(FilesystemUtilities.get_executable_directory() + "mods/")



func _load_translations() -> void:
	TranslationUtilities.load_translations(TranslationUtilities.TRANSLATION_DIR_PATH)
