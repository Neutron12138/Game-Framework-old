extends Control



@onready var start_game : VBoxContainer = %start_game
@onready var more : VBoxContainer = %more



func _on_start_pressed() -> void:
	more.hide()
	start_game.visible = not start_game.visible


func _on_settings_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(Resources.SettingsInterface.instantiate())


func _on_more_pressed() -> void:
	start_game.hide()
	more.visible = not more.visible

func _on_quit_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.make_quit_confirmation()


func _on_new_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(Resources.NewGame.instantiate())


func _on_load_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(Resources.LoadGame.instantiate())


func _on_mods_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(Resources.ModsManager.instantiate())


func _on_help_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(Resources.Help.instantiate())


func _on_about_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(Resources.About.instantiate())
