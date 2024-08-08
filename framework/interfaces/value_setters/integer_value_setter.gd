extends "value_setter.gd"



@export var min_value : int = 0
@export var max_value : int = 100
@export var allow_greater : bool = false
@export var allow_lesser : bool = false
@export var default_value : int = 0
@onready var value : SpinBox = %value



func _ready() -> void:
	super._ready()
	reset()



func reset() -> void:
	value.value = default_value
	value.min_value = min_value
	value.max_value = max_value
	value.allow_greater = allow_greater
	value.allow_lesser = allow_lesser



func get_value() -> Variant:
	return value.value



func _on_value_value_changed(_value: float) -> void:
	value_changed.emit(get_value())
