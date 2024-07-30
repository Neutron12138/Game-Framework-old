extends Node2D



@onready var fsm : StateMachine = %fsm
@onready var label : Label = %label



func _process(delta: float) -> void:
	label.text = fsm.get_state_string()
