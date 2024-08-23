class_name FreeCamera3DController
extends BasicCamera3DController



@export var camera : NormalCamera3D = null



func rotate_camera(relative : Vector2) -> void:
	if not is_instance_valid(camera):
		return
	
	var vector : Vector2 = relative.rotated(-camera.roll)
	var delta : Vector2 = vector * rotation_ratio * FramesPerSecond.process_delta
	
	camera.yaw += delta.x
	camera.pitch += delta.y



func roll_camera(delta : float) -> void:
	if not is_instance_valid(camera):
		return
	
	var axis : float = Input.get_axis("roll_right", "roll_left")
	camera.roll += axis * roll_ratio * delta



func move_camera(delta : float) -> void:
	if not is_instance_valid(camera):
		return
	
	var vec : Vector2 = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var dir : Vector3 = vec.x * camera.right + vec.y * camera.front
	var vel : Vector3 = dir.normalized() * motion_velocity
	camera.global_position += vel * delta
