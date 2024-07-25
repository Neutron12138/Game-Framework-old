extends VBoxContainer



@export var previous_scene : Node = null
@onready var settings : VBoxContainer = %settings



func _ready() -> void:
	settings.settings = GameSettings.new(get_tree().game_settings)
	settings.reset()



func apply(current_tab : String) -> void:
	get_tree().game_settings = settings.settings
	var game_settings : GameSettings = get_tree().game_settings
	
	var err : Error = ResourceSaver.save(game_settings, FilesystemUtilities.get_executable_directory() + GameSettings.GAMESETTINGS_FILENAME)
	if err != OK:
		push_error("Unable to save configuration file and apply changes, reason: \"" +\
		error_string(err) + "\".")
		SceneTreeUtilities.make_error_dialog("TEXT_FAILED_TO_APPLY_SETTINGS")
		return
	
	var utils : GameSettingsUtilities = GameSettingsUtilities.new(game_settings)
	match current_tab:
		GameSettings.SECTION_WINDOW:
			utils.apply_window()
		GameSettings.SECTION_SYSTEM:
			utils.apply_system()



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_settings_confirmed(current_tab : String) -> void:
	apply(current_tab)
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_settings_canceled(_current_tab : String) -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_settings_applied(current_tab : String) -> void:
	apply(current_tab)
