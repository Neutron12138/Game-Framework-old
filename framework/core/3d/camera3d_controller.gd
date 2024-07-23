class_name Camera3DController
extends Node



@export var camera : NormalCamera3D = null
@export var velocity : float = 2.0



func _process(delta: float) -> void:
	var vec : Vector2 = Input.get_vector("left", "right", "backward", "forward")
	var dir : Vector3 = vec.x * camera.right + vec.y * camera.front
	var vel : Vector3 = dir * velocity
	camera.global_position += vel * delta
