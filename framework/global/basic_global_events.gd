class_name BasicGlobalEvents
extends RefCounted


signal game_crashed

signal scene_changed(old_scene : Node, new_scene : Node)

signal mod_enabled(mod : BasicModification)
signal mod_disabled(mod : BasicModification)
signal mod_priority_changed(mod : BasicModification, priority : int)
signal mod_settings_opened(mod : BasicModification, settings : VBoxContainer)
signal mod_settings_closed(mod : BasicModification, settings : VBoxContainer)
