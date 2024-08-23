extends HBoxContainer



@export var label : String = "":
	set(value):
		label = value
		if is_instance_valid(label_label):
			label_label.text = label
@export var text : String = "":
	set(value):
		text = value
		if is_instance_valid(label_label):
			text_label.text = text

@onready var label_label : Label = %label
@onready var text_label : Label = %text



func _ready() -> void:
	label_label.text = label
	text_label.text = text
