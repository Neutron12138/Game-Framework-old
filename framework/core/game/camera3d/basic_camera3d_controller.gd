class_name BasicCamera3DController
extends Node



@export var enable_motion : bool = true
@export var motion_velocity : float = 2.0
@export var enable_rotation : bool = true
@export var rotation_ratio : float = deg_to_rad(10.0)
@export var enable_roll : bool = false
@export var roll_ratio : float = deg_to_rad(30.0)



func _process(delta: float) -> void:
	if enable_motion:
		move_camera(delta)
	if enable_roll:
		roll_camera(delta)



func _unhandled_input(event: InputEvent) -> void:
	if not enable_rotation:
		return
	
	if event is InputEventMouseMotion:
		rotate_camera(event.relative)



func rotate_camera(_relative : Vector2) -> void:
	pass

func roll_camera(_delta : float) -> void:
	pass

func move_camera(_delta : float) -> void:
	pass

