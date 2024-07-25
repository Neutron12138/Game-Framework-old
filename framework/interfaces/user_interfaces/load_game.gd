extends VBoxContainer



@export var previous_scene : Node = null



func _ready() -> void:
	pass



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)



