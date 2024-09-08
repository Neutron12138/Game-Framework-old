extends PanelContainer



@export var text : String = "":
	set(value):
		text = value
		if is_instance_valid(text_label):
			text_label.text = value

@onready var text_label : Label = %text_label
@onready var buttons : VBoxContainer = %buttons
