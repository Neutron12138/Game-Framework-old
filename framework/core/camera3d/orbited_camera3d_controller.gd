class_name OrbitedCamera3DController
extends BasicCamera3DController



enum ZoomMethod { ADD, MUL }



@export var target : Node3D = null
@export var camera : OrbitedCamera3D = null
@export var zoom_method : ZoomMethod = ZoomMethod.MUL
@export var zoom_factor : float = 1.1



func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	if not is_instance_valid(camera):
		return
	
	super._process(delta)
	camera.center = target.global_position



func _unhandled_input(event: InputEvent) -> void:
	super._unhandled_input(event)
	
	if not is_instance_valid(target):
		return
	if not is_instance_valid(camera):
		return
	
	if not event is InputEventMouseButton:
		return
	
	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom_camera(event.factor)
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom_camera(-event.factor)



func zoom_camera(factor : float) -> void:
	if zoom_method == ZoomMethod.MUL:
		camera.distance *= pow(zoom_factor, factor)
	else:
		camera.distance += factor * zoom_factor



func rotate_camera(relative : Vector2) -> void:
	if not is_instance_valid(target):
		return
	if not is_instance_valid(camera):
		return
	
	var vector : Vector2 = relative.rotated(-camera.roll)
	var delta : Vector2 = vector * rotation_ratio * FramesPerSecond.process_delta
	
	camera.yaw += -delta.x
	camera.pitch += delta.y



func roll_camera(delta : float) -> void:
	if not is_instance_valid(target):
		return
	if not is_instance_valid(camera):
		return
	
	var axis : float = Input.get_axis("roll_right", "roll_left")
	camera.roll -= axis * roll_ratio * delta



func move_camera(delta : float) -> void:
	if not is_instance_valid(target):
		return
	if not is_instance_valid(camera):
		return
	
	var vec : Vector2 = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var dir : Vector3 = -vec.x * camera.right + vec.y * camera.front
	var vel : Vector3 = dir.normalized() * motion_velocity
	target.position += vel * delta
