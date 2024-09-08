extends "value_setter.gd"



@export var enum_items : Dictionary = {}
@export var default_index : int = -1

@onready var value : OptionButton = %value



func _ready() -> void:
	super._ready()
	reset()



func reset() -> void:
	value.clear()
	for key in enum_items:
		value.add_item(str(key))
	value.selected = default_index



func get_value() -> Variant:
	var index : int = value.selected
	if index == -1:
		Logger.loge("No valid item selected.")
		return null
	
	var key : Variant = enum_items.keys()[index]
	return enum_items[key]



func get_index_by_value(val : Variant) -> int:
	var array : Array = enum_items.keys()
	var key : Variant = enum_items.find_key(val)
	if key == null:
		Logger.loge("Unable to find the key corresponding to the value (\"%s\") in enum_items." % val)
		return -1
	return array.find(key)



func _on_value_item_selected(_index: int) -> void:
	value_changed.emit(get_value())
