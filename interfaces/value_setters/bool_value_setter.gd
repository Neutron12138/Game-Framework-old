extends "value_setter.gd"



@export var default_value : bool = false
@onready var button : CheckButton = $button



func _ready() -> void:
	super._ready()
	reset()



func reset() -> void:
	button.button_pressed = default_value



func get_value() -> Variant:
	return button.button_pressed
