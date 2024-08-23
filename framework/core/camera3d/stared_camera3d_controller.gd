class_name StaredCamera3DController
extends BasicCamera3DController



@export var target : Node3D = null
@export var camera : StaredCamera3D = null



func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	if not is_instance_valid(camera):
		return
	
	super._process(delta)
	camera.center = target.global_position
