extends VBoxContainer



@export var previous_scene : Node = null

@onready var filename : LineEdit = %filename
@onready var file_picker : FileDialog = %file_picker



func _on_header_back_request() -> void:
	SceneTreeUtilities.backward_layered_scene(previous_scene)



func _on_pick_pressed() -> void:
	file_picker.size = get_window().size
	file_picker.current_dir = FilesystemUtilities.get_executable_directory() + GameDataUtilities.GAMESAVE_DIRNAME
	file_picker.show()



func _on_load_pressed() -> void:
	pass



func _on_file_picker_file_selected(path: String) -> void:
	filename.text = path
