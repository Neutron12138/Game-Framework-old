extends Node3D



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
