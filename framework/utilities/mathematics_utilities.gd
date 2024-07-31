class_name MathematicsUtilities
extends RefCounted



static func calc_euler_angle(yaw : float, pitch : float) -> Vector3:
	var y : float = sin(pitch)
	var h : float = cos(pitch)
	var x : float = -sin(yaw) * h
	var z : float = -cos(yaw) * h
	return Vector3(x, y, z)
