extends Node



var process_delta : float = 0.0
var physics_process_delta : float = 0.0
var processes_per_second : float = 0.0
var physics_processes_per_second : float = 0.0



func _process(delta: float) -> void:
	process_delta = delta
	processes_per_second = 1.0 / delta



func _physics_process(delta: float) -> void:
	physics_process_delta = delta
	physics_processes_per_second = 1.0 / delta
