extends StateMachine



enum State { IDLE, CHASE, ATTACK }



@onready var idle : StateNode = %idle
@onready var chase : StateNode = %chase
@onready var attack : StateNode = %attack
var state : State = State.IDLE



func get_state_string() -> String:
	match state:
		State.IDLE:
			return "idle"
		State.CHASE:
			return "chase"
		State.ATTACK:
			return "attack"
		_:
			return "null"



func update() -> void:
	match state:
		State.IDLE:
			if idle.player_found():
				change_state(chase)
				state = State.CHASE
		
		State.CHASE:
			if chase.player_lost():
				change_state(idle)
				state = State.IDLE
			elif chase.range_entered():
				change_state(attack)
				state = State.ATTACK
		
		State.ATTACK:
			if attack.range_exited():
				change_state(chase)
				state = State.CHASE
