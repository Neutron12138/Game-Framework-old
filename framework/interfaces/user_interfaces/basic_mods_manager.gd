extends VBoxContainer



@export var previous_scene : Node = null
@onready var container : HBoxContainer = %container
@onready var list : ItemList = %list
@onready var blank : Control = %blank
var settings : VBoxContainer = null



func _ready() -> void:
	for identity in BasicGlobalRegistry.modifications.keys():
		list.add_item(identity)



func close() -> void:
	if is_instance_valid(settings):
		settings.close()
		container.remove_child(settings)



func open(index : int) -> void:
	var identity : String = list.get_item_text(index)
	if not BasicGlobalRegistry.modifications.has(identity):
		return
	
	settings = FrameworkResources.BasicModSettings.instantiate()
	settings.open(BasicGlobalRegistry.modifications[identity])
	container.add_child(settings)



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void:
	close()
	blank.show()


func _on_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	close()
	open(index)
	blank.hide()
