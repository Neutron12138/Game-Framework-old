class_name OrbitedCamera3D
extends StaredCamera3D



@export var min_distance : float = 0.5
@export var max_distance : float = 10.0



var distance : float = 1.0:
	set(value):
		distance = clampf(value, min_distance, max_distance)
		update()



func calc_vectors() -> void:
	var dir : Vector3 = MathematicsUtilities.calc_euler_angle(yaw, pitch)
	front = -dir
	global_position = center + dir * distance
	up = MathematicsUtilities.calc_euler_up(yaw, pitch, roll)
	right = -front.cross(up)
