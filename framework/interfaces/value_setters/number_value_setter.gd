extends "string_value_setter.gd"



@export var integer_mode : bool = false
@export var enable_check : bool = true



func get_value() -> Variant:
	var text : String = value.text
	
	if integer_mode:
		if not enable_check:
			return int(text)
		
		if not text.is_valid_int():
			SceneTreeUtilities.make_error_dialog("TEXT_PLEASE_ENTER_INTEGER")
			return null
		
		return int(text)
	
	else:
		if not enable_check:
			return float(text)
		
		if not text.is_valid_float():
			SceneTreeUtilities.make_error_dialog("TEXT_PLEASE_ENTER_FLOAT")
			return null
		
		return float(text)
