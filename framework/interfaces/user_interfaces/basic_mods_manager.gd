extends VBoxContainer



@export var previous_scene : Node = null
@onready var enable_mods : HBoxContainer = %enable_mods
@onready var container : HBoxContainer = %container
@onready var list : ItemList = %list
@onready var blank : Control = %blank
var settings : VBoxContainer = null



func _ready() -> void:
	if not is_instance_valid(BasicGlobalRegistry.mods_settings):
		return
	
	enable_mods.default_value = BasicGlobalRegistry.mods_settings.get_value(
		ModsManagerUtilities.SECTION_GLOBAL,
		ModsManagerUtilities.KEY_ENABLE_MODS,
		false)
	enable_mods.reset()
	
	for identity in BasicGlobalRegistry.modifications.keys():
		list.add_item(identity)



func close() -> void:
	if is_instance_valid(settings):
		settings.close()
		settings.queue_free()
		settings = null



func open(index : int) -> void:
	var identity : String = list.get_item_text(index)
	if not BasicGlobalRegistry.modifications.has(identity):
		return
	
	settings = FrameworkResources.BasicModSettings.instantiate()
	container.add_child(settings)
	settings.open(BasicGlobalRegistry.modifications[identity])



func _on_header_back_request() -> void:
	SceneTreeUtilities.temp_scene_back(previous_scene)


func _on_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void:
	close()
	blank.show()


func _on_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	close()
	open(index)
	blank.hide()


func _on_enable_mods_value_changed(value: Variant) -> void:
	if not is_instance_valid(BasicGlobalRegistry.mods_settings):
		return
	
	BasicGlobalRegistry.mods_settings.set_value(
		ModsManagerUtilities.SECTION_GLOBAL,
		ModsManagerUtilities.KEY_ENABLE_MODS,
		value)
	ModsManagerUtilities.save_mods_settings()
