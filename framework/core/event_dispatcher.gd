class_name EventDispatcher
extends Node



signal mouse_button_pressed(button_index : MouseButton, position : Vector2)
signal mouse_button_released(button_index : MouseButton, position : Vector2)
signal mouse_wheel_rolled(factor : float, position : Vector2)
signal mouse_moved(relative : Vector2, velocity : Vector2, position : Vector2)

signal mouse_button_left_pressed(position : Vector2)
signal mouse_button_left_released(position : Vector2)
signal mouse_button_right_pressed(position : Vector2)
signal mouse_button_right_released(position : Vector2)
signal mouse_button_middle_pressed(position : Vector2)
signal mouse_button_middle_released(position : Vector2)



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_mouse_motion(event)
	elif event is InputEventMouseButton:
		_handle_mouse_button(event)



func _handle_mouse_motion(event : InputEventMouseMotion) -> void:
	mouse_moved.emit(event.relative, event.velocity, event.position)



func _handle_mouse_button(event : InputEventMouseButton) -> void:
	if event.pressed:
		mouse_button_pressed.emit(event.button_index, event.position)
	else:
		mouse_button_released.emit(event.button_index, event.position)
	
	
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			_handle_mouse_button_left(event)
		MOUSE_BUTTON_RIGHT:
			_handle_mouse_button_right(event)
		MOUSE_BUTTON_MIDDLE:
			_handle_mouse_button_middle(event)
		MOUSE_BUTTON_WHEEL_UP:
			mouse_wheel_rolled.emit(event.factor, event.position)
		MOUSE_BUTTON_WHEEL_DOWN:
			mouse_wheel_rolled.emit(-event.factor, event.position)




func _handle_mouse_button_left(event : InputEventMouseButton) -> void:
	if event.pressed:
		mouse_button_left_pressed.emit(event.position)
	else:
		mouse_button_left_released.emit(event.position)



func _handle_mouse_button_right(event : InputEventMouseButton) -> void:
	if event.pressed:
		mouse_button_right_pressed.emit(event.position)
	else:
		mouse_button_right_released.emit(event.position)



func _handle_mouse_button_middle(event : InputEventMouseButton) -> void:
	if event.pressed:
		mouse_button_middle_pressed.emit(event.position)
	else:
		mouse_button_middle_released.emit(event.position)
