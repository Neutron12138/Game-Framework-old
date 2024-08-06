extends VBoxContainer



@export var previous_scene : Node = null
@onready var list : ItemList = %list
@onready var options : VBoxContainer = %options
@onready var blank : Control = %blank



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void:
	options.hide()
	blank.show()


func _on_list_item_selected(index: int) -> void:
	options.switch(index)
	options.show()
	blank.hide()
