class_name OrbitedCamera3D
extends BasicCamera3D



@export var min_distance : float = 0.5
@export var max_distance : float = 10.0



var distance : float = 1.0:
	set(value):
		distance = clampf(value, min_distance, max_distance)
		update()

var center : Vector3 = Vector3.FORWARD:
	set(value):
		center = value
		update()



func calc_vectors() -> void:
	var dir : Vector3 = MathematicsUtilities.calc_euler_angle(yaw, pitch)
	global_position = center + dir * distance
	right = (global_position - center).cross(up)



func update() -> void:
	calc_vectors()
	look_at(center, up)
