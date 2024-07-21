extends "string_value_setter.gd"



@export var value_type : Variant.Type = TYPE_FLOAT



func get_value() -> Variant:
	var text : String = value.text
	
	if value_type == TYPE_INT:
		return int(text)
	elif value_type == TYPE_FLOAT:
		return float(text)
	else:
		return 0
