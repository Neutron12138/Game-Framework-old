extends Node



@onready var scene_tree : SceneTree = get_tree()
@onready var window : Window = get_window()
@onready var current_scene : Node = get_tree().current_scene



func _ready() -> void:
	change_scene.call_deferred(Resources.StartMenu.instantiate())
	window.connect("close_requested", make_quit_confirmation)



func change_scene(new_scene : Node, remove_old_one : bool = true) -> Error:
	if not is_instance_valid(new_scene):
		push_error("Unable to change scene to an invalid node.")
		return ERR_INVALID_PARAMETER
	
	if remove_old_one:
		scene_tree.unload_current_scene()
	
	window.add_child(new_scene)
	scene_tree.current_scene = new_scene
	current_scene = new_scene
	
	return OK



func make_quit_confirmation(exit_code: int = 0) -> void:
	var dialog : ConfirmationDialog = Resources.QuitConfirmationDialog.instantiate()
	dialog.exit_code = exit_code
	window.add_child(dialog)



func change_size_with_window(control : Control) -> void:
	window.connect("size_changed", func(): control.size = window.size)
