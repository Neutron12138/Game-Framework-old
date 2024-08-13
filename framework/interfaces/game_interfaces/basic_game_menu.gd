extends VBoxContainer



signal continue_game
signal load_game
signal save_game
signal game_settings
signal quit_game



@onready var game_options : CenterContainer = %game_options



func _on_game_options_pressed() -> void:
	game_options.show()


func _on_continue_pressed() -> void:
	continue_game.emit()


func _on_load_pressed() -> void:
	load_game.emit()


func _on_save_pressed() -> void:
	save_game.emit()


func _on_settings_pressed() -> void:
	game_settings.emit()


func _on_quit_pressed() -> void:
	quit_game.emit()
