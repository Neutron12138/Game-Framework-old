extends Node

func _ready() -> void:
	ModificationUtilities.initialize_mods(ModificationUtilities.mod_initializers, get_tree())
