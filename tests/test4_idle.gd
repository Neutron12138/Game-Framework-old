extends StateNode



@export var enemy : Sprite2D = null
@export var view_range : float = 500.0



func player_found() -> bool:
	var pos : Vector2 = get_viewport().get_mouse_position()
	var dis : Vector2 = enemy.position - pos
	if dis.length() <= view_range:
		return true
	return false
