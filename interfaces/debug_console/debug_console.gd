extends VBoxContainer



@onready var output : ItemList = $output
@onready var simple_code_edit : LineEdit = $simple/simple_code_edit



func _on_advanced_pressed() -> void:
	pass


func _on_simple_code_edit_text_submitted(new_text: String) -> void:
	pass
	#print(new_text)
	#DebugUtilities.run_gdscript_string(new_text)


func _on_simple_submit_pressed() -> void:
	DebugUtilities.run_gdscript_line(simple_code_edit.text)
