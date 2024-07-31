class_name NormalCamera3D
extends BasicCamera3D



var front : Vector3 = Vector3.FORWARD



func calc_vectors() -> void:
	front = MathematicsUtilities.calc_euler_angle(yaw, pitch)
	right = front.cross(up)



func update() -> void:
	calc_vectors()
	look_at(global_position + front, up)
