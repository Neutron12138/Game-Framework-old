extends ConfirmationDialog

@export var exit_code : int = 0

func _on_canceled() -> void:
	queue_free()

func _on_confirmed() -> void:
	get_tree().quit(exit_code)
