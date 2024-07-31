class_name BasicCamera3D
extends Camera3D



const PITCH_ANGLE_LIMIT : float = deg_to_rad(89.9)



var enable_limit : bool = true
var pitch : float = 0.0 :
	set(value):
		if enable_limit:
			pitch = clampf(value, -PITCH_ANGLE_LIMIT, PITCH_ANGLE_LIMIT)
		else:
			pitch = wrapf(value, -PI, PI)
		update()
var yaw : float = 0.0 :
	set(value):
		yaw = wrapf(value, 0, TAU)
		update()

var right : Vector3 = Vector3.RIGHT
var up : Vector3 = Vector3.UP



func _ready() -> void:
	update()



func calc_vectors() -> void:
	pass



func update() -> void:
	pass
