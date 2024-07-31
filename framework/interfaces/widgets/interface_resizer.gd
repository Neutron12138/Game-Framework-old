class_name InterfaceResizer
extends Node



@export var target : Control = null



func _ready() -> void:
	resize()
	get_window().connect("size_changed", resize)



func resize() -> void:
	target.set_size.call_deferred(get_window().size)

