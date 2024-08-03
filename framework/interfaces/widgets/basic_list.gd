class_name BasicList
extends Control



@export var data : Array = []:
	set(value):
		update()
@export var item_scene : Node = null:
	set(value):
		item_scene = value
		update()
@export var item_container : Node = null:
	set(value):
		item_container = value
		SceneTreeUtilities.clear_children(item_container)
		update()



func _ready() -> void:
	if is_valid():
		update()
		return
	
	item_scene = Label.new()
	item_container = VBoxContainer.new()



func is_valid() -> bool:
	if not is_instance_valid(item_scene):
		return false
	if not is_instance_valid(item_container):
		return false
	return true



func _resize_container() -> void:
	pass



func _adapt_item(item : Variant, node : Node) -> void:
	pass



func update() -> void:
	if not is_valid():
		return
	
	_resize_container()
	for i in range(data.size()):
		_adapt_item(data[i], item_container.get_children()[i])
