extends VBoxContainer



@export var previous_scene : Node = null
@onready var settings : VBoxContainer = $settings
@onready var configuration : Configuration = get_tree().configuration



func _ready() -> void:
	SceneTreeUtilities.set_size_with_window(self)
	SceneTreeUtilities.change_size_with_window(self)
	settings.configuration = Configuration.new(configuration)



func back() -> void:
	if is_instance_valid(previous_scene):
		SceneTreeUtilities.change_scene(previous_scene)
		if previous_scene is CanvasItem or previous_scene is Node3D:
			previous_scene.show()
	else:
		queue_free()



func _on_back_pressed() -> void:
	back()


func _on_settings_on_confirmed() -> void:
	back()


func _on_settings_on_canceled() -> void:
	back()


func _on_settings_on_applied() -> void:
	pass
