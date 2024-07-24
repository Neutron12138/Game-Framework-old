extends Node



@onready var scene_tree : SceneTree = get_tree()
@onready var window : Window = get_window()
@onready var current_scene : Node = get_tree().current_scene



func _ready() -> void:
	var utils : GameSettingsUtilities = GameSettingsUtilities.new(scene_tree.game_settings, window)
	utils.apply_all()
	
	window.connect("close_requested", make_quit_confirmation)
	change_to_new_scene.call_deferred(Resources.StartMenu.instantiate())
	#change_to_new_scene.call_deferred(load("res://tests/test_2.tscn").instantiate())
	
	ModificationUtilities.initialize_mods(ModificationUtilities.mod_initializers, scene_tree)



func _process(_delta: float) -> void:
	DebugConsoleUtilities.open_debug_console(scene_tree.game_settings)



func is_scene_valid(scene : Node) -> bool:
	if not is_instance_valid(scene):
		push_error("Unable to change scene to an invalid node.")
		return false
	
	return true



func _change_scene(scene : Node, remove_old_one : bool = true) -> void:
	if remove_old_one:
		current_scene.queue_free()
	
	scene_tree.current_scene = scene
	current_scene = scene_tree.current_scene

func change_scene(scene : Node, remove_old_one : bool = true) -> Error:
	if not is_scene_valid(scene):
		return ERR_INVALID_PARAMETER
	
	_change_scene(scene, remove_old_one)
	return OK



func _change_to_new_scene(new_scene : Node, remove_old_one : bool = true) -> void:
	window.add_child(new_scene)
	_change_scene(new_scene, remove_old_one)

func change_to_new_scene(new_scene : Node, remove_old_one : bool = true) -> Error:
	if not is_scene_valid(new_scene):
		return ERR_INVALID_PARAMETER
	
	_change_to_new_scene(new_scene, remove_old_one)
	return OK



func _change_to_temp_scene(temp_scene : Node) -> void:
	if current_scene is CanvasItem or current_scene is Node3D:
		current_scene.hide()
	
	temp_scene.previous_scene = current_scene
	_change_to_new_scene(temp_scene, false)

func change_to_temp_scene(temp_scene : Node) -> Error:
	if not is_scene_valid(temp_scene):
		return ERR_INVALID_PARAMETER
	
	_change_to_temp_scene(temp_scene)
	return OK



func temp_scene_back(previous_scene : Node) -> void:
	if is_instance_valid(previous_scene):
		SceneTreeUtilities.change_scene(previous_scene)
		if previous_scene is CanvasItem or previous_scene is Node3D:
			previous_scene.show()
	else:
		SceneTreeUtilities.change_scene(Resources.Blank.instantiate())



func init_dialog(dialog : AcceptDialog, title : String, text : String, on_confirmed : Callable = Callable(), on_canceled : Callable = Callable()) -> void:
	if not is_instance_valid(dialog):
		push_error("The dialog object to be initialized cannot be a null pointer.")
		return
	
	dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	dialog.title = title
	dialog.dialog_text = text
	dialog.ok_button_text = "TEXT_CONFIRM"
	if dialog is ConfirmationDialog:
		dialog.cancel_button_text = "TEXT_CANCEL"
	
	if on_confirmed.is_valid():
		dialog.confirmed.connect(on_confirmed)
	if on_canceled.is_valid():
		dialog.canceled.connect(on_canceled)

func make_dialog(dialog : Window, title : String, text : String, on_confirmed : Callable = Callable(), on_canceled : Callable = Callable()) -> void:
	init_dialog(dialog, title, text, on_confirmed, on_canceled)
	
	if not on_confirmed.is_valid():
		dialog.confirmed.connect(func(): dialog.queue_free())
	if not on_canceled.is_valid():
		dialog.canceled.connect(func(): dialog.queue_free())
	
	dialog.show()
	window.add_child(dialog)



func make_accept_dialog(title : String, text : String, on_confirmed : Callable = Callable(), on_canceled : Callable = Callable()) -> void:
	var dialog : AcceptDialog = AcceptDialog.new()
	make_dialog(dialog, title, text, on_confirmed, on_canceled)

func make_confirmation_dialog(title : String, text : String, on_confirmed : Callable = Callable(), on_canceled : Callable = Callable()) -> void:
	var dialog : ConfirmationDialog = ConfirmationDialog.new()
	make_dialog(dialog, title, text, on_confirmed, on_canceled)

func make_error_dialog(text : String, on_confirmed : Callable = Callable()) -> void:
	make_accept_dialog("TEXT_ERROR", text, on_confirmed)

func make_warning_dialog(text : String, on_confirmed : Callable = Callable()) -> void:
	make_accept_dialog("TEXT_WARNING", text, on_confirmed)



func make_quit_confirmation(exit_code: int = 0) -> void:
	var dialog : ConfirmationDialog = ConfirmationDialog.new()
	dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	make_dialog(dialog, "TEXT_PLEASE_CONFIRM", "TEXT_QUIT_OR_NOT",
	func() : scene_tree.quit(exit_code))
