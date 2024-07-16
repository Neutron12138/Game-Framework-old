extends "value_setter.gd"



@export var enable_int_enter : bool = false
@export var default_x_value : String = "0"
@export var default_y_value : String = "0"

@onready var x_edit : LineEdit = $x_edit
@onready var y_edit : LineEdit = $y_edit



func _ready() -> void:
	super._ready()
	reset()



func reset() -> void:
	x_edit.text = default_x_value
	y_edit.text = default_y_value



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
