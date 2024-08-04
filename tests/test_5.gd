extends VBoxContainer



var count : int = 0


func _ready() -> void:
	pass
	$ScrollContainer/TextListAdapter.data = range(0, 100)
	$ScrollContainer/TextListAdapter.update()


func _on_text_list_adapter_item_clicked(index: int) -> void:
	print(index)



func _on_timer_timeout() -> void:
	#$ScrollContainer/TextListAdapter.append_item(count)
	$ScrollContainer/TextListAdapter.remove_item($ScrollContainer/TextListAdapter.data.size() - 1)
	count += 1
