extends VBoxContainer



@export var previous_scene : Node = null



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_cancel_pressed() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_advanced_pressed() -> void:
	pass


func _on_confirm_pressed() -> void:
	pass
