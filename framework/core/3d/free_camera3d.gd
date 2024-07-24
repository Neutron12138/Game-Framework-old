class_name FreeCamera3D
extends NormalCamera3D



@export var velocity : float = 2.0
@export var ratio : Vector2 = Vector2(deg_to_rad(0.2), deg_to_rad(0.2))
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



func rotate_camera(relative : Vector2) -> void:
	yaw += relative.x * ratio.x
	pitch += relative.y * ratio.y



func move_camera(delta : float) -> void:
	var vec : Vector2 = Input.get_vector("left", "right", "backward", "forward")
	var dir : Vector3 = vec.x * right + vec.y * front
	var vel : Vector3 = dir.normalized() * velocity
	global_position += vel * delta
