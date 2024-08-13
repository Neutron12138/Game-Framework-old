class_name BasicStateMachine
extends Node



signal started
signal stopped
signal paused
signal resumed
signal state_changed(previous_state : StringName)



const STATUS_STOPPED : StringName = &"stopped"
const STATUS_RUNNING : StringName = &"running"
const STATUS_PAUSED : StringName = &"paused"
const EMPTY_STATE : StringName = &""



@export var start_state : StringName = BasicStateMachine.EMPTY_STATE
@export var auto_start : bool = true
var current_state : StringName = EMPTY_STATE
var status : StringName = STATUS_STOPPED



func _ready() -> void:
	if auto_start:
		start(start_state)



func is_started() -> bool:
	return status == STATUS_RUNNING or status == STATUS_PAUSED

func is_running() -> bool:
	return status == STATUS_RUNNING

func is_paused() -> bool:
	return status == STATUS_PAUSED



func start(state : StringName = EMPTY_STATE) -> void:
	current_state = state
	status = STATUS_RUNNING
	started.emit()



func stop() -> void:
	current_state = EMPTY_STATE
	status = STATUS_STOPPED
	stopped.emit()



func pause() -> void:
	if not is_started():
		Logger.loge("The state machine has not started running yet.")
		return
	
	status = STATUS_PAUSED
	paused.emit()



func resume() -> void:
	if not is_started():
		Logger.loge("The state machine has not started running yet.")
		return
	
	status = STATUS_RUNNING
	resumed.emit()



func update() -> void:
	pass



func change_state(target_state : StringName) -> void:
	var previous_state : String = current_state
	current_state = target_state
	state_changed.emit(previous_state)
