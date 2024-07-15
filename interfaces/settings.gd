extends VBoxContainer



signal on_confirmed
signal on_canceled
signal on_applied



@export var configuration : Configuration = null
@onready var window_settings : ScrollContainer = $window_settings
@onready var mods_settings : ScrollContainer = $mods_settings



func _on_window_tab_pressed() -> void:
	window_settings.visible = not window_settings.visible
	mods_settings.hide()


func _on_mods_tab_pressed() -> void:
	window_settings.hide()
	mods_settings.visible = not mods_settings.visible


func _on_confirm_pressed() -> void:
	emit_signal("on_confirmed")
	print($ValueSetter.get_value())


func _on_cancel_pressed() -> void:
	emit_signal("on_canceled")


func _on_apply_pressed() -> void:
	emit_signal("on_applied")
