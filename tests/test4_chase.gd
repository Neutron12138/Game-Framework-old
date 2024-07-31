extends StateNode



@export var enemy : Sprite2D = null
@export var speed : float = 100
@export var view_range : float = 500.0
@export var attack_range : float = 100.0



func _process(delta: float) -> void:
	var pos : Vector2 = get_viewport().get_mouse_position()
	var vec : Vector2 = pos - enemy.position
	var dir : Vector2 = vec.normalized()
	var vel : Vector2 = dir * speed
	enemy.position += vel * delta



func player_lost() -> bool:
	var pos : Vector2 = get_viewport().get_mouse_position()
	var dis : Vector2 = enemy.position - pos
	if dis.length() > view_range:
		return true
	return false



func range_entered() -> bool:
	var pos : Vector2 = get_viewport().get_mouse_position()
	var dis : Vector2 = enemy.position - pos
	if dis.length() < attack_range:
		return true
	return false

