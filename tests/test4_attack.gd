extends StateNode



@export var enemy : Sprite2D = null
@export var attack_range : float = 100.0



func range_exited() -> bool:
	var pos : Vector2 = get_viewport().get_mouse_position()
	var dis : Vector2 = enemy.position - pos
	if dis.length() > attack_range:
		return true
	return false
