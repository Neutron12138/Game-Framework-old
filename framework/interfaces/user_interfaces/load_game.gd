extends VBoxContainer



@export var previous_scene : Node = null
@onready var list : ItemList = %list



func _ready() -> void:
	pass



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_cancel_pressed() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_delete_pressed() -> void:
	pass


func _on_load_pressed() -> void:
	pass
