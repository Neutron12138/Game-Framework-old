extends VBoxContainer



@onready var title : Label = %title
@onready var output_log : ItemList = %output_log
@onready var command_edit : LineEdit = %command_edit
@onready var submit : Button = %submit
var command : DebugConsoleCommand = DebugConsoleCommand.new(self)
var previous_scene : Node = null
var paused : bool = false



func _ready() -> void:
	title.text = tr(title.text)
	submit.text = tr(submit.text)



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_console") and not visible:
		show()
		SceneTreeUtilities.change_to_temp_scene(self, false)
		
		if BasicGlobalRegistry.game_settings.pause_when_console:
			get_tree().paused = paused
	
	elif Input.is_action_just_pressed("debug_console") and visible:
		hide()
		SceneTreeUtilities.temp_scene_back(previous_scene, false)
		
		if BasicGlobalRegistry.game_settings.pause_when_console:
			paused = get_tree().paused
			get_tree().paused = true



func log(text : String) -> void:
	output_log.add_item(text)



func _on_submit_pressed() -> void:
	command.execute_string(command_edit.text)



func _on_command_edit_text_submitted(_new_text: String) -> void:
	pass
