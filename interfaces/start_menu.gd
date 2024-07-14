extends Control



@onready var HUD : VBoxContainer = $HUD
@onready var start_game : VBoxContainer = $HUD/HBoxContainer/HBoxContainer/start_game
@onready var more : VBoxContainer = $HUD/HBoxContainer/HBoxContainer/more



func _ready() -> void:
	SceneTreeUtilities.set_size_with_window(HUD)
	SceneTreeUtilities.change_size_with_window(HUD)


func _on_start_pressed() -> void:
	more.hide()
	start_game.visible = not start_game.visible


func _on_settings_pressed() -> void:
	start_game.hide()
	more.hide()
	hide()
	
	var scene : Node = Resources.Settings.instantiate()
	scene.previous_scene = self
	SceneTreeUtilities.change_to_new_scene(scene, false)


func _on_more_pressed() -> void:
	start_game.hide()
	more.visible = not more.visible


func _on_quit_pressed() -> void:
	start_game.hide()
	more.hide()
	SceneTreeUtilities.make_quit_confirmation()


func _on_new_pressed() -> void:
	pass


func _on_load_pressed() -> void:
	pass


func _on_mods_pressed() -> void:
	pass


func _on_help_pressed() -> void:
	pass


func _on_about_pressed() -> void:
	pass # Replace with function body.
