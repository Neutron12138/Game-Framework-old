extends Node2D



@onready var fsm : StateMachineNode = %fsm
@onready var label : Label = %label



func _process(delta: float) -> void:
	label.text = "status: %s\nstate: %s" % [fsm.status, fsm.current_state]
