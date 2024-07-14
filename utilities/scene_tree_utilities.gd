extends Node



@onready var scene_tree : SceneTree = get_tree()
@onready var window : Window = get_window()
@onready var current_scene : Node = get_tree().current_scene



func _ready() -> void:
	change_to_new_scene.call_deferred(Resources.StartMenu.instantiate())
	window.connect("close_requested", make_quit_confirmation)



func change_scene(scene : Node, remove_old_one : bool = true) -> Error:
	if not is_instance_valid(scene):
		push_error("Unable to change scene to an invalid node.")
		return ERR_INVALID_PARAMETER
	
	if remove_old_one:
		current_scene.queue_free()
	
	scene_tree.current_scene = scene
	current_scene = scene
	return OK



func change_to_new_scene(new_scene : Node, remove_old_one : bool = true) -> Error:
	window.add_child(new_scene)
	return change_scene(new_scene, remove_old_one)



func make_quit_confirmation(exit_code: int = 0) -> void:
	var dialog : ConfirmationDialog = Resources.QuitConfirmationDialog.instantiate()
	dialog.exit_code = exit_code
	window.add_child(dialog)



func set_size_with_window(control : Control) -> void:
	control.size = window.size

func change_size_with_window(control : Control) -> void:
	window.connect("size_changed", func(): set_size_with_window(control))
