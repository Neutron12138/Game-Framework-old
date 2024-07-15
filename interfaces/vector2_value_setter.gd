extends "value_setter.gd"



@export var enable_int_enter : bool = false
@onready var x_edit : LineEdit = $x_edit
@onready var y_edit : LineEdit = $y_edit



func get_value() -> Variant:
	var x : String = x_edit.text
	var y : String = y_edit.text
	
	if enable_int_enter:
		if not (x.is_valid_int() and y.is_valid_int()):
			SceneTreeUtilities.make_error_dialog("TEXT_PLEASE_ENTER_INT")
		return Vector2i(int(x), int(y))
	else:
		if not (x.is_valid_float() and y.is_valid_float()):
			SceneTreeUtilities.make_error_dialog("TEXT_PLEASE_ENTER_FLOAT")
		return Vector2(float(x), float(y))
