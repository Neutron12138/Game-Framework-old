extends Node

func _ready() -> void:
	ModificationUtilities.initialize_mods(get_tree().mod_initializers, get_tree())
