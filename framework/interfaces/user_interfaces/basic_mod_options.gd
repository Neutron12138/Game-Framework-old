extends VBoxContainer



@export var modification : BasicModification = null
@onready var enable : VBoxContainer = %enable
@onready var priority : VBoxContainer = %priority
@onready var options : ScrollContainer = %options



func _ready() -> void:
	reset(modification)



func reset(mod : BasicModification) -> void:
	modification = mod
	if not is_instance_valid(modification):
		return
	
	
