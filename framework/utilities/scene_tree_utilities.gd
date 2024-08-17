extends Node



@onready var scene_tree : SceneTree = get_tree()
@onready var window : Window = get_window()
@onready var current_scene : Node = get_tree().current_scene



func _ready() -> void:
	var utils : GameSettingsUtilities = GameSettingsUtilities.new(BasicGlobalRegistry.game_settings, window)
	utils.apply_all()
	
	window.connect("close_requested", make_quit_confirmation)
	change_to_new_scene.call_deferred(FrameworkResources.BasicStartMenu.instantiate())
	#change_to_new_scene.call_deferred(load("res://tests/test_6.tscn").instantiate())
	
	ModsManagerUtilities.initialize_mods(BasicGlobalRegistry.mod_initializers, scene_tree)



func is_scene_valid(scene : Node) -> bool:
	if not is_instance_valid(scene):
		Logger.loge("Unable to change scene to an invalid node.")
		return false
	
	return true



#region change scene

func _change_scene(scene : Node, remove_old_one : bool = true) -> void:
	var old_scene : Node = scene_tree.current_scene
	scene_tree.current_scene = scene
	current_scene = scene_tree.current_scene
	
	BasicGlobalRegistry.global_events.scene_changed.emit(old_scene, scene)
	
	if remove_old_one:
		old_scene.queue_free()

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



func _change_to_temp_scene(temp_scene : Node, new_one : bool = true) -> void:
	if (current_scene is CanvasItem) or (current_scene is Node3D):
		current_scene.hide()
	
	temp_scene.previous_scene = current_scene
	
	if new_one:
		_change_to_new_scene(temp_scene, false)
	else:
		_change_scene(temp_scene, false)

func change_to_temp_scene(temp_scene : Node, new_one : bool = true) -> Error:
	if not is_scene_valid(temp_scene):
		return ERR_INVALID_PARAMETER
	
	_change_to_temp_scene(temp_scene, new_one)
	return OK



func temp_scene_back(previous_scene : Node, remove_temp_scene : bool = true) -> void:
	if not is_instance_valid(previous_scene):
		SceneTreeUtilities.change_scene(FrameworkResources.Blank.instantiate())
		return
	
	SceneTreeUtilities.change_scene(previous_scene, remove_temp_scene)
	if previous_scene is CanvasItem or previous_scene is Node3D:
		previous_scene.show()

#endregion



#region dialog

func init_dialog(dialog : AcceptDialog, title : String, text : String, on_confirmed : Callable = Callable(), on_canceled : Callable = Callable()) -> void:
	if not is_instance_valid(dialog):
		Logger.loge("The dialog object to be initialized cannot be a null pointer.")
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

#endregion



#region node children

func in_exceptions(node : Node, exceptions : Array = []) -> bool:
	return (node.name in exceptions) or (node in exceptions)



func get_children_ex(node : Node, exceptions : Array = [], include_internal: bool = false) -> Array[Node]:
	if not is_instance_valid(node):
		Logger.loge("The node cannot be an null pointer.")
		return []
	
	var children : Array[Node] = []
	for child in node.get_children(include_internal):
		if not in_exceptions(child, exceptions):
			children.append(child)
	return children



func clear_children(node : Node, exceptions : Array = [], include_internal: bool = false) -> void:
	if not is_instance_valid(node):
		Logger.loge("The node cannot be an null pointer.")
		return
	
	for child in get_children_ex(node, exceptions, include_internal):
		child.queue_free()



func count_children(node : Node, exceptions : Array = [], include_internal: bool = false) -> int:
	if not is_instance_valid(node):
		Logger.loge("The node cannot be an null pointer.")
		return 0
	
	if exceptions.is_empty():
		return node.get_child_count(include_internal)
	
	return get_children_ex(node, exceptions, include_internal).size()

#endregion
