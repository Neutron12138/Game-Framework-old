class_name BasicListAdapter
extends Node



@export var data : Array = []
@export var container : Control = null:
	set(value):
		container = value
		update()



func append_item(content : Variant) -> void:
	data.append(content)
	update()

func insert_item(index : int, content : Variant) -> void:
	data.insert(index, content)
	update()

func erase_item(content : Variant) -> void:
	data.erase(content)
	update()

func remove_item(index : int) -> void:
	data.remove_at(index)
	update()

func clear_items() -> void:
	data.clear()
	update()



func update() -> void:
	if not is_instance_valid(container):
		return
	
	SceneTreeUtilities.clear_children(container, [self])
	for i in range(data.size()):
		var item : Control = _adapt_item(i, data[i])
		if is_instance_valid(item):
			container.add_child(item)

func _adapt_item(_index : int, _content : Variant) -> Control:
	return null

