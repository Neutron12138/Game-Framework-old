class_name TrackedCamera3DController
extends BasicCamera3DController



@export var target : Node3D = null
@export var camera : OrbitedCamera3D = null
@export var zoom_speed : float = 0.2



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
		camera.distance -= event.factor * zoom_speed
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		camera.distance += event.factor * zoom_speed



func rotate_camera(relative : Vector2) -> void:
	if not is_instance_valid(target):
		return
	if not is_instance_valid(camera):
		return
	
	camera.yaw -= relative.x * rotation_ratio.x
	camera.pitch += relative.y * rotation_ratio.y
