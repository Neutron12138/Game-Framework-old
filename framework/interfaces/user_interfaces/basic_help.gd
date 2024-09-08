extends VBoxContainer



@export var previous_scene : Node = null



func _on_header_back_request() -> void:
	SceneTreeUtilities.backward_layered_scene(previous_scene)
