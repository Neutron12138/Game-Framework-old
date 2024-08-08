extends VBoxContainer



@export var modification : BasicModification = null
@onready var settings : VBoxContainer = %settings
@onready var details : HBoxContainer = %details
@onready var icon : TextureRect = %icon
@onready var info : Label = %info
@onready var enable : HBoxContainer = %enable
@onready var priority : HBoxContainer = %priority



func open(mod : BasicModification) -> void:
	modification = mod
	if not is_instance_valid(modification):
		return
	
	var texture : Texture = ModFileUtilities.load_mod_icon(modification)
	if is_instance_valid(texture):
		icon.texture = texture
	info.text = ModFileUtilities.get_mod_info(modification)
	
	enable.default_value = BasicGlobalRegistry.mods_settings.get_value(mod.identity, ModsManagerUtilities.KEY_ENABLE, false)
	enable.reset()
	
	priority.default_value = BasicGlobalRegistry.mods_settings.get_value(mod.identity, ModsManagerUtilities.KEY_PRIORITY, 0)
	priority.reset()
	
	if is_instance_valid(BasicGlobalRegistry.global_events):
		BasicGlobalRegistry.global_events.mod_settings_opened.emit(modification, settings)



func close() -> void:
	modification = null
	
	if is_instance_valid(BasicGlobalRegistry.global_events):
		BasicGlobalRegistry.global_events.mod_settings_closed.emit(modification, settings)



func _on_enable_value_changed(value: Variant) -> void:
	if not is_instance_valid(BasicGlobalRegistry.global_events):
		return
	
	if value:
		BasicGlobalRegistry.global_events.mod_enabled.emit(modification)
	else:
		BasicGlobalRegistry.global_events.mod_disabled.emit(modification)


func _on_priority_value_changed(value: Variant) -> void:
	if not is_instance_valid(BasicGlobalRegistry.global_events):
		return
	
	BasicGlobalRegistry.global_events.mod_priority_changed.emit(modification, value)
