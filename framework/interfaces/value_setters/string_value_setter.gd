extends "value_setter.gd"



@export var default_value : String = ""
@onready var value : LineEdit = %value



func _ready() -> void:
	reset()



func reset() -> void:
	value.text = default_value



func get_value() -> Variant:
	return value.text
