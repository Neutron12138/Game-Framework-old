extends Control



@onready var HUD : VBoxContainer = $HUD
@onready var start_game : VBoxContainer = $HUD/HBoxContainer/HBoxContainer/start_game
@onready var more : VBoxContainer = $HUD/HBoxContainer/HBoxContainer/more


	
func _ready() -> void:
	HUD.size = get_window().size
	get_window().connect("size_changed", func(): HUD.size = get_window().size)


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
	pass


func _on_load_pressed() -> void:
	pass


func _on_mods_pressed() -> void:
	pass


func _on_help_pressed() -> void:
	pass


func _on_about_pressed() -> void:
	start_game.hide()
	more.hide()
	
	SceneTreeUtilities.change_to_temp_scene(Resources.About.instantiate())
