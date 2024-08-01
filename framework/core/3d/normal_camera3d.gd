class_name NormalCamera3D
extends BasicCamera3D



func calc_vectors() -> void:
	front = MathematicsUtilities.calc_euler_angle(yaw, pitch)
	up = MathematicsUtilities.calc_euler_up(yaw, pitch, roll)
	right = front.cross(up)



func update() -> void:
	calc_vectors()
	look_at(global_position + front, up)
