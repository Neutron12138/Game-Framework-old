class_name Main
extends SceneTree



static var global_data : Dictionary = {}
var mod_initializers : Array[Object] = []
var configuration : Configuration = null



func _initialize() -> void:
	_load_configuration()
	_load_modifications()
	_load_translations()
	auto_accept_quit = false



func _load_configuration() -> void:
	ResourceLoader.add_resource_format_loader(Configuration.Loader.new())
	ResourceSaver.add_resource_format_saver(Configuration.Saver.new())
	
	var filename : String = FilesystemUtilities.get_executable_directory() + Configuration.CONFIGURATION_FILENAME
	if not FileAccess.file_exists(filename):
		configuration = Configuration.new()
	else:
		var configs : Configuration = load(filename) as Configuration
		if is_instance_valid(configs):
			configuration = configs
		else:
			configuration = Configuration.new()
	
	
	apply_configuration()



func apply_configuration() -> void:
	pass



func _load_modifications() -> void:
	var edir : String = FilesystemUtilities.get_executable_directory() + "mods/"
	if DirAccess.dir_exists_absolute(edir):
		ModificationUtilities.load_deep_mods_from_dir(edir)
	
	var udir : String = FilesystemUtilities.get_user_data_directory() + "mods/"
	if DirAccess.dir_exists_absolute(udir):
		ModificationUtilities.load_deep_mods_from_dir(udir)
	
	var mdir : String = ModificationUtilities.MOD_INIT_DIR_PATH
	if DirAccess.dir_exists_absolute(mdir):
		mod_initializers = ModificationUtilities.load_mod_initializers_from_dir(mdir)
	
	ModificationUtilities.initialize_mods(mod_initializers)



func _load_translations() -> void:
	var translations : Array[Translation] = TranslationUtilities.load_translations_from_dir(TranslationUtilities.TRANSLATION_DIR_PATH)
	TranslationUtilities.add_translations(translations)
