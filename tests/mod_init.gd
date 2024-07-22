extends RefCounted

func initialize() -> void:
	print(123)

func ready(_scene_tree : SceneTree) -> void:
	print(456)
