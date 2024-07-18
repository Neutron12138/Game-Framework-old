extends Window



@export var previous_scene : Node = null



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_console"):
		visible = not visible



func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		hide()
