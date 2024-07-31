extends VBoxContainer



@onready var title : Label = %title
@onready var output_log : ItemList = %output_log
@onready var command_edit : LineEdit = %command_edit
@onready var submit : Button = %submit
var command : DebugConsoleCommand = DebugConsoleCommand.new(self)
var previous_scene : Node = null



func _ready() -> void:
	title.text = tr(title.text)
	submit.text = tr(submit.text)



func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	
	if event.keycode != KEY_QUOTELEFT:
		return

	if visible and event.pressed:
		hide()
		SceneTreeUtilities.temp_scene_back(previous_scene, false)
		
		if Engine.get_main_loop().game_settings.pause_when_console:
			get_tree().paused = false
	
	elif (not visible) and event.pressed:
		show()
		SceneTreeUtilities.change_to_temp_scene(self, false)
		
		if Engine.get_main_loop().game_settings.pause_when_console:
			get_tree().paused = true



func log(text : String) -> void:
	output_log.add_item(text)



func _on_submit_pressed() -> void:
	command.execute_string(command_edit.text)



func _on_command_edit_text_submitted(_new_text: String) -> void:
	#print(new_text)
	#DebugUtilities.run_gdscript_string(new_text)
	pass
