extends "value_setter.gd"



@export var enum_items : Dictionary = {}
@export var default_index : int = -1

@onready var options : OptionButton = $options



func _ready() -> void:
	super._ready()
	reset()



func reset() -> void:
	for key in enum_items:
		options.add_item(str(key))
	options.selected = default_index



func get_value() -> Variant:
	var index : int = options.selected
	var key : Variant = enum_items.keys()[index]
	return enum_items[key]



func get_index_by_value(value : Variant) -> int:
	var array : Array = enum_items.keys()
	var key : Variant = enum_items.find_key(value)
	if key == null:
		push_error("Unable to find the key corresponding to the value (\"" +\
		str(value) + "\") in enum_items.")
		return -1
	return array.find(key)
