class_name BasicCamera3DController
extends Node



@export var motion_velocity : float = 2.0
@export var rotation_ratio : Vector2 = Vector2(deg_to_rad(0.2), deg_to_rad(0.2))
@export var enable_rotation : bool = true
@export var enable_motion : bool = true



func _process(delta: float) -> void:
	if enable_motion:
		move_camera(delta)



func _unhandled_input(event: InputEvent) -> void:
	if not enable_rotation:
		return
	
	if event is InputEventMouseMotion:
		rotate_camera(event.relative)



func rotate_camera(_relative : Vector2) -> void:
	pass



func move_camera(_delta : float) -> void:
	pass

