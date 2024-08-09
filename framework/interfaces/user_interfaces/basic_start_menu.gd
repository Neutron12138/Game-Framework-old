extends VBoxContainer



@onready var start_game : VBoxContainer = %start_game
@onready var more : VBoxContainer = %more



func _on_start_pressed() -> void:
	more.hide()
	start_game.visible = not start_game.visible


func _on_settings_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(FrameworkResources.BasicSettingsInterface.instantiate())


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
	SceneTreeUtilities.change_to_temp_scene(FrameworkResources.BasicNewGame.instantiate())


func _on_load_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(FrameworkResources.BasicLoadGame.instantiate())


func _on_mods_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(FrameworkResources.BasicModsManager.instantiate())


func _on_help_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(FrameworkResources.BasicHelp.instantiate())


func _on_about_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.change_to_temp_scene(FrameworkResources.BasicAbout.instantiate())
