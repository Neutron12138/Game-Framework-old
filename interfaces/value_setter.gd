extends HBoxContainer



@export var label_text : String
@onready var label : Label = $label



func _ready() -> void:
	label.text = label_text



func get_value() -> Variant:
	return null
