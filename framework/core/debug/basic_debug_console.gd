extends VBoxContainer



@export var previous_scene : Node = null
@onready var title : Label = %title
@onready var output_log : ItemList = %output_log
@onready var command_edit : LineEdit = %command_edit
@onready var submit : Button = %submit
var command : DebugConsoleCommand = DebugConsoleCommand.new(self)
var paused : bool = false



func _ready() -> void:
	title.text = tr(title.text)
	submit.text = tr(submit.text)



func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("debug_console"):
		return
	
	if visible:
		hide()
		SceneTreeUtilities.backward_layered_scene(previous_scene, false)
		
		if BasicGlobalRegistry.game_settings.pause_when_console:
			paused = get_tree().paused
			get_tree().paused = true
	
	else:
		show()
		SceneTreeUtilities.forward_layered_scene(self)
		
		if BasicGlobalRegistry.game_settings.pause_when_console:
			get_tree().paused = paused



func clear() -> void:
	output_log.clear()



func log(text : String) -> void:
	output_log.add_item(text)



func _on_submit_pressed() -> void:
	command.execute_string(command_edit.text)



func _on_command_edit_text_submitted(_new_text: String) -> void:
	pass
