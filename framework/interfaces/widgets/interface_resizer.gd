class_name InterfaceResizer
extends Node



@export var target : Control = null:
	set(value):
		_disconnect()
		target = value
		_connect()
@export var viewport : Viewport = null:
	set(value):
		_disconnect()
		viewport = value
		_connect()



func _ready() -> void:
	if not is_instance_valid(viewport):
		viewport = get_window()



func _disconnect() -> void:
	if not is_instance_valid(viewport):
		return
	
	if viewport.is_connected("size_changed", resize):
		viewport.disconnect("size_changed", resize)



func _connect() -> void:
	if not (is_instance_valid(target) and is_instance_valid(viewport)):
		return
	
	resize()
	viewport.connect("size_changed", resize)



func resize() -> void:
	if is_instance_valid(target) and is_instance_valid(viewport):
		target.set_size.call_deferred(viewport.size)

