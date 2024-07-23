extends VBoxContainer



@export var previous_scene : Node = null
@onready var title : Label = %title
@onready var output_log : ItemList = %output_log
@onready var command_edit : LineEdit = %command_edit
@onready var submit : Button = %submit
var command : DebugConsoleCommand = DebugConsoleCommand.new(self)



func _ready() -> void:
	title.text = tr(title.text)
	submit.text = tr(submit.text)



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_console"):
		SceneTreeUtilities.temp_scene_back(previous_scene)
		#DebugConsoleUtilities.close_debug_console(get_tree().game_settings)


func _notification(what: int) -> void:
	if what == NOTIFICATION_EXIT_TREE:
		DebugConsoleUtilities.close_debug_console(get_tree().game_settings)


func log(text : String) -> void:
	output_log.add_item(text)



func _on_submit_pressed() -> void:
	command.execute_string(command_edit.text)



func _on_command_edit_text_submitted(_new_text: String) -> void:
	#print(new_text)
	#DebugUtilities.run_gdscript_string(new_text)
	pass
