class_name StateMachine
extends Node



signal started
signal stopped
signal paused
signal resumed
signal node_changed(previous_node : StateNode)



enum Status { STOPPED, RUNNING, PAUSED }



@export var start_node : StateNode = null
@export var auto_start : bool = true
var current_node : StateNode = null
var status : Status = Status.STOPPED



func _ready() -> void:
	if auto_start:
		start()



func _process(_delta: float) -> void:
	if status == Status.RUNNING:
		update()



func start() -> void:
	current_node = start_node
	if is_instance_valid(current_node):
		current_node.enable()
	
	status = Status.RUNNING
	started.emit()



func stop() -> void:
	if is_instance_valid(current_node):
		current_node.disable()
	
	current_node = null
	status = Status.STOPPED
	stopped.emit()



func pause() -> void:
	if is_instance_valid(current_node):
		current_node.disable()
	
	status = Status.PAUSED
	paused.emit()



func resume() -> void:
	if is_instance_valid(current_node):
		current_node.enable()
	
	status = Status.RUNNING
	resumed.emit()



func update() -> void:
	pass



func change_state(target_node : StateNode) -> void:
	var previous_node : StateNode = current_node
	
	if is_instance_valid(current_node):
		current_node.exit_state()
	current_node = target_node
	if is_instance_valid(current_node):
		current_node.enter_state()
	
	node_changed.emit(previous_node)



func change_state_by_name(target_name : String) -> void:
	var target_node : StateNode = get_node(target_name)
	if not is_instance_valid(target_node):
		Logger.loge("Failed to get state node: \"%s\"." % target_name)
	
	change_state(target_node)
