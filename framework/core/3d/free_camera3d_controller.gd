class_name FreeCamera3DController
extends BasicCamera3DController



@export var camera : NormalCamera3D = null



func rotate_camera(relative : Vector2) -> void:
	if not is_instance_valid(camera):
		return
	
	camera.yaw += relative.x * rotation_ratio.x
	camera.pitch += relative.y * rotation_ratio.y



func move_camera(delta : float) -> void:
	if not is_instance_valid(camera):
		return
	
	var vec : Vector2 = Input.get_vector("left", "right", "backward", "forward")
	var dir : Vector3 = vec.x * camera.right + vec.y * camera.front
	var vel : Vector3 = dir.normalized() * motion_velocity
	camera.global_position += vel * delta
