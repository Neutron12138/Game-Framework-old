extends "value_setter.gd"



signal value_submitted(value : String)



@export var default_value : String = ""
@onready var value : LineEdit = %value



func _ready() -> void:
	reset()



func reset() -> void:
	value.text = default_value



func get_value() -> Variant:
	return value.text



func _on_value_text_changed(_new_text: String) -> void:
	value_changed.emit(get_value())


func _on_value_text_submitted(_new_text: String) -> void:
	value_submitted.emit(get_value())
