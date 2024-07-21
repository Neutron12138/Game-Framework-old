extends VBoxContainer



@export var previous_scene : Node = null
@onready var options : OptionButton = %options
@onready var content : Label = %content



func _ready() -> void:
	show_game_framework_license()



func show_game_framework_license() -> void:
	var file : FileAccess = FilesystemUtilities.open_readonly_file(Constants.GAME_FRAMEWORK_LICENSE_PATH)
	if not is_instance_valid(file):
		SceneTreeUtilities.make_error_dialog("TEXT_FAILED_TO_READ_GF_LICENSE")
		content.text = "TEXT_FAILED_TO_READ_GF_LICENSE"
		return
	
	content.text = file.get_as_text()



func show_godot_engine_license() -> void:
	content.text = Engine.get_license_text()



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)



func _on_options_item_selected(index: int) -> void:
	match options.get_item_text(index):
		"TEXT_GAME_FRAMEWORK_LICENSE":
			show_game_framework_license()
		"TEXT_GODOT_ENGINE_LICENSE":
			show_godot_engine_license()
