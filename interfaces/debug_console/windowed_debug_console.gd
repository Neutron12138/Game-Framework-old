extends Window



func close_console() -> void:
	queue_free()
	DebugConsoleUtilities.close_debug_console(get_tree().game_settings)



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_console"):
		close_console()



func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		close_console()
