class_name TextListAdapter
extends BasicListAdapter



signal item_clicked(index : int)



func update() -> void:
	if not is_instance_valid(container):
		return
	
	var children : Array[Node] = SceneTreeUtilities.get_children_ex(container, [self])
	
	if children.size() < data.size():
		for i in range(children.size(), data.size()):
			var item : Button = _adapt_item(i, null)
			children.append(item)
			container.add_child(item)
	elif children.size() > data.size():
		for i in range(data.size(), children.size()):
			container.remove_child(children.pop_back())
	
	for i in range(data.size()):
		_adapt_item_content(children[i], i, data[i])



func _adapt_item_content(item : Button, _index : int, content : Variant) -> void:
	item.text = str(content)




func _adapt_item(index : int, _content : Variant) -> Control:
	var item : Button = Button.new()
	item.set_meta("index", index)
	item.name = str(index)
	item.alignment = HORIZONTAL_ALIGNMENT_LEFT
	item.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	item.connect("pressed", func(): _pressed(item))
	return item



func _pressed(item : Button) -> void:
	item_clicked.emit(item.get_meta("index"))
