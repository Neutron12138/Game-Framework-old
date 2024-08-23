extends "value_setter.gd"



signal value_submitted(value : Variant)



@export var integer_mode : bool = false
@export var enable_check : bool = true
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
	
	if integer_mode:
		if not enable_check:
			return Vector2i(int(x), int(y))
		
		if not (x.is_valid_int() and y.is_valid_int()):
			SceneTreeUtilities.make_error_dialog("TEXT_PLEASE_ENTER_INT")
			return null
		
		return Vector2i(int(x), int(y))
	
	else:
		if not enable_check:
			return Vector2(float(x), float(y))
		
		if not (x.is_valid_float() and y.is_valid_float()):
			SceneTreeUtilities.make_error_dialog("TEXT_PLEASE_ENTER_FLOAT")
			return null
		
		return Vector2(float(x), float(y))



func _on_value_x_text_changed(_new_text: String) -> void:
	value_changed.emit(get_value())


func _on_value_x_text_submitted(_new_text: String) -> void:
	value_submitted.emit(get_value())


func _on_value_y_text_changed(_new_text: String) -> void:
	value_changed.emit(get_value())


func _on_value_y_text_submitted(_new_text: String) -> void:
	value_submitted.emit(get_value())
