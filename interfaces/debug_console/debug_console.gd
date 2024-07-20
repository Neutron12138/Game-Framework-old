extends VBoxContainer



@onready var title : Label = $header/title
@onready var advanced : Button = $header/advanced
@onready var output : ItemList = $output
@onready var simple_code_edit : LineEdit = $simple/simple_code_edit
@onready var simple_submit : Button = $simple/simple_submit



func _ready() -> void:
	title.text = tr(title.text)
	advanced.text = tr(advanced.text)
	simple_submit.text = tr(simple_submit.text)



func _on_advanced_pressed() -> void:
	pass


func _on_simple_code_edit_text_submitted(new_text: String) -> void:
	pass
	#print(new_text)
	#DebugUtilities.run_gdscript_string(new_text)


func _on_simple_submit_pressed() -> void:
	DebugUtilities.run_gdscript_line(simple_code_edit.text, {
		"output" : output,
		"scene_tree" : get_tree()
	})
