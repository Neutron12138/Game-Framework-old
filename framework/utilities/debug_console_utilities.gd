class_name DebugConsoleUtilities
extends RefCounted



static var is_running : bool = false



static func open_debug_console(game_settings : GameSettings) -> void:
	if not Input.is_action_just_pressed("debug_console"):
		return
	
	if is_running:
		return
	
	if not game_settings.enable_debug_console:
		return
	
	if game_settings.enable_windowed_console:
		pass#SceneTreeUtilities.scene_tree.root.add_child(Resources.DebugConsoleWindow.instantiate())
	else:
		pass#SceneTreeUtilities.change_to_temp_scene(Resources.DebugConsole.instantiate())
	
	if game_settings.pause_when_console:
		SceneTreeUtilities.scene_tree.paused = true
	
	is_running = true



static func close_debug_console(game_settings : GameSettings) -> void:
	is_running = false
	
	if game_settings.pause_when_console:
		SceneTreeUtilities.scene_tree.paused = false

