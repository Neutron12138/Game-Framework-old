extends HBoxContainer



signal back_request



@export var title : String = ""
@onready var label : Label = $label



func _ready() -> void:
	label.text = title



func _on_back_pressed() -> void:
	back_request.emit()
