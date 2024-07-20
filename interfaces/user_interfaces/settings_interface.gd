extends VBoxContainer



@export var previous_scene : Node = null
@onready var settings : VBoxContainer = %settings



func _ready() -> void:
	size = get_window().size
	get_window().connect("size_changed", func(): size = get_window().size)
	settings.configuration = Configuration.new(get_tree().configuration)
	settings.reset()



func apply(current_tab : String) -> void:
	get_tree().configuration = settings.configuration
	var configuration : Configuration = get_tree().configuration
	
	var err : Error = ResourceSaver.save(configuration, FilesystemUtilities.get_executable_directory() + Configuration.CONFIGURATION_FILENAME)
	if err != OK:
		push_error("Unable to save configuration file and apply changes, reason: \"" +\
		error_string(err) + "\".")
		SceneTreeUtilities.make_error_dialog("TEXT_FAILED_TO_APPLY_SETTINGS")
		return
	
	var utils : ConfigurationUtilities = ConfigurationUtilities.new(configuration)
	match current_tab:
		Configuration.SECTION_WINDOW:
			utils.apply_window()
		Configuration.SECTION_MODS:
			utils.apply_mods()



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_settings_confirmed(current_tab : String) -> void:
	apply(current_tab)
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_settings_canceled(_current_tab : String) -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_settings_applied(current_tab : String) -> void:
	apply(current_tab)
