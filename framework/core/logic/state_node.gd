class_name StateNode
extends Node



signal state_entered
signal state_exited



func _init() -> void:
	disable()



func enter_state() -> void:
	enable()
	state_entered.emit()



func exit_state() -> void:
	disable()
	state_exited.emit()



func enable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT



func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
