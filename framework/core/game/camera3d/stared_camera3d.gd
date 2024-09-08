class_name StaredCamera3D
extends BasicCamera3D



var center : Vector3:
	set(value):
		center = value
		update()



func _ready() -> void:
	center = global_position + Vector3.FORWARD



func calc_vectors() -> void:
	front = center - global_position
	right = front.cross(up)



func update() -> void:
	calc_vectors()
	look_at(center, up)
