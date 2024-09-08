class_name ModFileLoader
extends RefCounted



#region load mod files

static func load_resource_pack(path : String, mod_path : String, replace_files: bool = true) -> Error:
	if not FileAccess.file_exists(path):
		Logger.loge("The file (\"%s\") in modification (\"%s\") does not exist." % [path, mod_path])
		return ERR_FILE_NOT_FOUND
	
	var success : bool = ProjectSettings.load_resource_pack(path, replace_files)
	
	if not success:
		Logger.loge("Failed to load resource pack: \"%s\"." % path)
		return FAILED
	
	return OK



static func load_mod_initializer(path : String, mod_path : String, skip_cr : bool = false) -> Object:
	var object : Object = GDScriptUtilities.load_gdscript_from_file(path, skip_cr)
	if not is_instance_valid(object):
		Logger.loge("Failed to load the initializer (\"%s\") of the modification (\"%s\")." % [path, mod_path])
	
	return object



static func load_mod_icon(mod : BasicModification) -> Texture:
	if mod.icon.is_empty():
		return null
	
	var path : String = FilesystemUtilities.analyse_path(mod.icon, mod.directory)
	var image : Image = Image.load_from_file(path)
	var texture : ImageTexture = ImageTexture.create_from_image(image)
	if not is_instance_valid(texture):
		Logger.loge("Failed to load icon: \"%s\"." % mod.icon)
		return null
	
	return texture

#endregion



static func _load_mod_files(mod : BasicModification) -> void:
	for i in range(mod.files.size()):
		var file : Dictionary = mod.files[i]
		var path : String = FilesystemUtilities.analyse_path(file[BasicModification.KEY_PATH], mod.directory)
		var type : StringName = file[BasicModification.KEY_TYPE]
		
		if path.is_empty():
			Logger.loge("The file path is empty and cannot be loaded, in the modification (\"%s\"), index: %d." % [path, i])
			continue
		
		match type:
			BasicModification.TYPE_INITIALIZER:
				var obj : Object = load_mod_initializer(path, mod.resource_path)
				if is_instance_valid(obj):
					BasicGlobalRegistry.mod_initializers.append(obj)
			
			BasicModification.TYPE_RESOURCE_PACK:
				var replace_files : bool = file.get(BasicModification.KEY_REPLACE_FILES, true)
				load_resource_pack(path, mod.resource_path, replace_files)
			
			BasicModification.TYPE_TRANSLATION:
				TranslationUtilities.load_add_translation(path)
			
			BasicModification.TYPE_TRANSLATION_DIR:
				TranslationUtilities.load_add_translation_dir(path)
			
			_:
				Logger.loge("Unknown file type (\"%s\") at index %d of files in modification (\"%s\")." % [type, i, mod.resource_path])

static func load_mod_files(mod : BasicModification) -> void:
	if not is_instance_valid(mod):
		Logger.loge("Unable to load an invalid modification.")
	
	_load_mod_files(mod)
