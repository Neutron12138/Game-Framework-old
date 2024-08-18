extends VBoxContainer



@export var previous_scene : Node = null
@onready var settings : VBoxContainer = %settings



func _ready() -> void:
	settings.settings = BasicGameSettings.new(BasicGlobalRegistry.game_settings)
	settings.reset()



func apply(current_tab : String) -> void:
	BasicGlobalRegistry.game_settings = settings.settings
	var game_settings : BasicGameSettings = BasicGlobalRegistry.game_settings
	
	var err : Error = ResourceSaver.save(game_settings, FilesystemUtilities.get_executable_directory() + BasicGameSettings.GAMESETTINGS_FILENAME)
	if err != OK:
		Logger.loge("Unable to save configuration file and apply changes, reason: \"%s\"." % error_string(err))
		SceneTreeUtilities.make_error_dialog("TEXT_FAILED_TO_APPLY_SETTINGS")
		return
	
	match current_tab:
		BasicGameSettings.SECTION_WINDOW:
			GameSettingsUtilities.apply_window(game_settings, get_window())
		BasicGameSettings.SECTION_SYSTEM:
			GameSettingsUtilities.apply_system(game_settings)



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_settings_confirmed(current_tab : String) -> void:
	apply(current_tab)
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_settings_canceled(_current_tab : String) -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_settings_applied(current_tab : String) -> void:
	apply(current_tab)
