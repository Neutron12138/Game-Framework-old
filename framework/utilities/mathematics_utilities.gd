class_name MathematicsUtilities
extends RefCounted



static func calc_euler_angle(yaw : float, pitch : float) -> Vector3:
	var y : float = sin(pitch)
	var h : float = cos(pitch)
	var x : float = -sin(yaw) * h
	var z : float = -cos(yaw) * h
	return Vector3(x, y, z)



static func calc_euler_plane_x(yaw : float, pitch : float) -> Vector3:
	return calc_euler_angle(yaw - PI / 2.0, pitch)

static func calc_euler_plane_y(yaw : float, pitch : float) -> Vector3:
	return calc_euler_angle(yaw, pitch + PI / 2.0)



static func calc_euler_up(yaw : float, pitch : float, roll : float) -> Vector3:
	var vx : Vector3 = calc_euler_plane_x(yaw, pitch)
	var vy : Vector3 = calc_euler_plane_y(yaw, pitch)
	var x : float = -sin(roll)
	var y : float = cos(roll)
	return x * vx + y * vy
