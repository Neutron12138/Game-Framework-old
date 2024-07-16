extends HBoxContainer



@export var label_text : String
@onready var label : Label = $label



func _ready() -> void:
	label.text = label_text



func reset() -> void:
	pass



func get_value() -> Variant:
	return null
