extends "value_setter.gd"



@export var default_value : bool = false
@onready var value : CheckButton = %value



func _ready() -> void:
	super._ready()
	reset()



func reset() -> void:
	value.button_pressed = default_value



func get_value() -> Variant:
	return value.button_pressed



func _on_value_pressed() -> void:
	value_changed.emit(get_value())
