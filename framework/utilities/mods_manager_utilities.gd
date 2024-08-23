class_name ModsManagerUtilities
extends RefCounted



const MOD_FILENAME : StringName = &"mod.json"
const MOD_DIRNAME : StringName = &"mods/"
const MODS_SETTINGS_FILENAME : StringName = &"mods.cfg"

const SECTION_GLOBAL : StringName = &"_global_"
const KEY_ENABLE_MODS : StringName = &"enable_mods"

const KEY_IDENTITY : StringName = &"identity"
const KEY_ENABLE : StringName = &"enable"
const KEY_PRIORITY : StringName = &"priority"

const METHOD_INITIALIZE : StringName = &"initialize"
const METHOD_READY : StringName = &"ready"



#region mod signals

static func on_mod_enabled(mod : BasicModification) -> void:
	if not is_instance_valid(mod):
		return
	
	BasicGlobalRegistry.mods_settings.set_value(mod.identity, KEY_ENABLE, true)
	save_mods_settings()

static func on_mod_disabled(mod : BasicModification) -> void:
	if not is_instance_valid(mod):
		return
	
	BasicGlobalRegistry.mods_settings.set_value(mod.identity, KEY_ENABLE, false)
	save_mods_settings()

static func on_mod_priority_changed(mod : BasicModification, priority : int) -> void:
	if not is_instance_valid(mod):
		return
	
	BasicGlobalRegistry.mods_settings.set_value(mod.identity, KEY_PRIORITY, priority)
	save_mods_settings() 

#endregion



#region mod settings

static func _check_mods_settings() -> void:
	for identity in BasicGlobalRegistry.mods_settings.get_sections():
		if identity == SECTION_GLOBAL:
			continue
		
		if BasicGlobalRegistry.mods_settings.has_section_key(identity, KEY_ENABLE):
			var enable : Variant = BasicGlobalRegistry.mods_settings.get_value(identity, KEY_ENABLE)
			if not enable is bool:
				Logger.loge("The type of the \"%s\" key in modification (identity: \"%s\") is incorrect and has been automatically changed to bool type with value: false." % [KEY_ENABLE, identity])
				BasicGlobalRegistry.mods_settings.set_value(identity, KEY_ENABLE, false)
		else:
			BasicGlobalRegistry.mods_settings.set_value(identity, KEY_ENABLE, false)
		
		if BasicGlobalRegistry.mods_settings.has_section_key(identity, KEY_PRIORITY):
			var priority : Variant = BasicGlobalRegistry.mods_settings.get_value(identity, KEY_PRIORITY)
			if not priority is int:
				Logger.loge("The type of the \"%s\" key in modification (identity: \"%s\") is incorrect and has been automatically changed to int type with value: 0." % [KEY_PRIORITY, identity])
				BasicGlobalRegistry.mods_settings.set_value(identity, KEY_PRIORITY, 0)
		else:
			BasicGlobalRegistry.mods_settings.set_value(identity, KEY_PRIORITY, 0)

static func check_mods_settings() -> void:
	if not is_instance_valid(BasicGlobalRegistry.mods_settings):
		return
	
	_check_mods_settings()



static func save_mods_settings() -> void:
	if not is_instance_valid(BasicGlobalRegistry.mods_settings):
		return
	
	_check_mods_settings()
	var path : String = FilesystemUtilities.get_executable_directory() + MODS_SETTINGS_FILENAME
	BasicGlobalRegistry.mods_settings.save(path)



static func load_mods_settings() -> void:
	var path : String = FilesystemUtilities.get_executable_directory() + MODS_SETTINGS_FILENAME
	BasicGlobalRegistry.mods_settings = ConfigFile.new()
	
	if FileAccess.file_exists(path):
		BasicGlobalRegistry.mods_settings.load(path)
	else:
		BasicGlobalRegistry.mods_settings.set_value(SECTION_GLOBAL, KEY_ENABLE_MODS, false)
		save_mods_settings()



static func _add_default_mod_settings(mod : BasicModification) -> void:
	if not is_instance_valid(BasicGlobalRegistry.mods_settings):
		return
	
	BasicGlobalRegistry.mods_settings.set_value(mod.identity, KEY_ENABLE, false)
	BasicGlobalRegistry.mods_settings.set_value(mod.identity, KEY_PRIORITY, 0)

static func add_default_mod_settings(mod : BasicModification) -> void:
	if not is_instance_valid(BasicGlobalRegistry.mods_settings):
		return
	
	_add_default_mod_settings(mod)

#endregion



#region load mod

static func load_modification(path : String) -> void:
	var mod : BasicModification = BasicModification.Loader.load(path)
	if not is_instance_valid(mod):
		return
	
	BasicGlobalRegistry.modifications[mod.identity] = mod
	if not BasicGlobalRegistry.mods_settings.has_section(mod.identity):
		_add_default_mod_settings(mod)
		save_mods_settings()



static func load_modifications(path : String) -> void:
	if not DirAccess.dir_exists_absolute(path):
		return
	
	var dirs : PackedStringArray = FilesystemUtilities.get_dirs_from_dir(path)
	for dir in dirs:
		var filename : String = dir + MOD_FILENAME
		if FileAccess.file_exists(filename):
			load_modification(filename)
	
	check_mods_settings()



static func _load_mods_files() -> void:
	var dict : Dictionary = {}
	for identity in BasicGlobalRegistry.mods_settings.get_sections():
		if identity == SECTION_GLOBAL:
			continue
		
		var enable : bool = BasicGlobalRegistry.mods_settings.get_value(identity, KEY_ENABLE, false)
		if not enable:
			continue
		
		var priority : int = BasicGlobalRegistry.mods_settings.get_value(identity, KEY_PRIORITY, 0)
		if not dict.has(priority):
			dict[priority] = []
		dict[priority].append(identity)
	
	var priorities : Array = dict.keys()
	priorities.sort()
	priorities.reverse()
	for priority in priorities:
		for identity in dict[priority]:
			if not BasicGlobalRegistry.modifications.has(identity):
				Logger.loge("Unable to find modification object: \"%s\"." % identity)
				continue
			
			ModFileUtilities.load_mod_files(BasicGlobalRegistry.modifications[identity])

static func load_mods_files() -> void:
	if not is_instance_valid(BasicGlobalRegistry.mods_settings):
		return
	
	_load_mods_files()

#endregion



#region initialize mod

static func initialize_mod(initializer : Object, scene_tree : SceneTree = null) -> void:
	if initializer.has_method(METHOD_INITIALIZE) and not is_instance_valid(scene_tree):
		initializer.call(METHOD_INITIALIZE)
	if initializer.has_method(METHOD_READY) and is_instance_valid(scene_tree):
		initializer.call(METHOD_READY, scene_tree)



static func initialize_mods(initializers : Array[Object], scene_tree : SceneTree = null) -> void:
	for init in initializers:
		initialize_mod(init, scene_tree)

#endregion
