extends VBoxContainer



@export
var previous_scene : Node = null



func _ready() -> void:
	SceneTreeUtilities.set_size_with_window(self)
	SceneTreeUtilities.change_size_with_window(self)



func _on_back_pressed() -> void:
	if is_instance_valid(previous_scene):
		SceneTreeUtilities.change_scene(previous_scene)
		if previous_scene is CanvasItem or previous_scene is Node3D:
			previous_scene.show()
	else:
		queue_free()
