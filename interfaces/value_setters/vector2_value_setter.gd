extends "value_setter.gd"



@export var enable_int_enter : bool = false
@export var default_value_x : String = "0"
@export var default_value_y : String = "0"

@onready var value_x : LineEdit = %value_x
@onready var value_y : LineEdit = %value_y



func _ready() -> void:
	super._ready()
	reset()



func reset() -> void:
	value_x.text = default_value_x
	value_y.text = default_value_y



func get_value() -> Variant:
	var x : String = value_x.text
	var y : String = value_y.text
	
	if enable_int_enter:
		if not (x.is_valid_int() and y.is_valid_int()):
			SceneTreeUtilities.make_error_dialog("TEXT_PLEASE_ENTER_INT")
		return Vector2i(int(x), int(y))
	else:
		if not (x.is_valid_float() and y.is_valid_float()):
			SceneTreeUtilities.make_error_dialog("TEXT_PLEASE_ENTER_FLOAT")
		return Vector2(float(x), float(y))
