extends StateMachineNode



const STATE_IDLE : StringName = &"idle"
const STATE_CHASE : StringName = &"chase"
const STATE_ATTACK : StringName = &"attack"



@onready var idle : StateNode = %idle
@onready var chase : StateNode = %chase
@onready var attack : StateNode = %attack



func update() -> void:
	match current_state:
		STATE_IDLE:
			if idle.player_found():
				change_state(STATE_CHASE)
		
		STATE_CHASE:
			if chase.player_lost():
				change_state(STATE_IDLE)
			elif chase.range_entered():
				change_state(STATE_ATTACK)
		
		STATE_ATTACK:
			if attack.range_exited():
				change_state(STATE_CHASE)
