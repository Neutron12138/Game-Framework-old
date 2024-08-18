extends Node



@onready var scene_tree : SceneTree = get_tree():
	set(value):
		if value != get_tree():
			Logger.loge("The \"scene_tree\" in \"SceneTreeUtilities\" is not allowed to be set.")
		if scene_tree != get_tree():
			scene_tree = get_tree()

@onready var window : Window = get_window():
	set(value):
		if value != get_window():
			Logger.loge("The \"window\" in \"SceneTreeUtilities\" is not allowed to be set.")
		if window != get_window():
			window = get_window()

@onready var current_scene : Node = get_tree().current_scene:
	set(value):
		var old_scene : Node = current_scene
		current_scene = value
		get_tree().current_scene = value
		
		if is_instance_valid(BasicGlobalRegistry.global_events):
			BasicGlobalRegistry.global_events.scene_changed.emit(old_scene, current_scene)

var layered_scene : LayeredScene = LayeredScene.new()



func _ready() -> void:
	GameSettingsUtilities.apply_all(BasicGlobalRegistry.game_settings, window)
	
	window.connect("close_requested", make_quit_confirmation)
	
	change_to_new_scene.call_deferred(FrameworkResources.BasicStartMenu.instantiate())
	#change_to_new_scene.call_deferred(load("res://tests/test_6.tscn").instantiate())
	
	ModsManagerUtilities.initialize_mods(BasicGlobalRegistry.mod_initializers, scene_tree)



#region change scene

func _change_scene(scene : Node, remove_old_one : bool = true) -> Error:
	if current_scene == scene:
		if remove_old_one:
			Logger.loge("Unable to change the scene to the current scene itself and delete it.")
			return ERR_INVALID_PARAMETER
		return OK
	
	var old_scene : Node = current_scene
	current_scene = scene
	
	if remove_old_one:
		old_scene.queue_free()
	
	return OK

func change_scene(scene : Node, remove_old_one : bool = true) -> Error:
	if not is_instance_valid(scene):
		Logger.loge("Unable to change scene to an invalid node.")
		return ERR_INVALID_PARAMETER
	
	return _change_scene(scene, remove_old_one)



func _change_to_new_scene(new_scene : Node, remove_old_one : bool = true) -> Error:
	if new_scene.is_inside_tree():
		Logger.logw("The new scene (%s) is already in the scene tree, there is no need to add it again." % str(new_scene))
	else:
		window.add_child(new_scene)
	
	return _change_scene(new_scene, remove_old_one)

func change_to_new_scene(new_scene : Node, remove_old_one : bool = true) -> Error:
	if not is_instance_valid(new_scene):
		Logger.loge("Unable to change scene to an invalid node.")
		return ERR_INVALID_PARAMETER
	
	return _change_to_new_scene(new_scene, remove_old_one)

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
