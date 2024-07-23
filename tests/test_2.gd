extends Node3D



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()



func _on_event_dispatcher_mouse_moved(relative: Vector2, velocity: Vector2, position: Vector2) -> void:
	#$NormalCamera3D.enable_limit = false
	$NormalCamera3D.yaw += relative.x / 500.0
	$NormalCamera3D.pitch += relative.y / 500.0
