class_name FilesystemUtilities
extends RefCounted



const PREFIX_MOD : StringName = &"mod://"
const PREFIX_RES : StringName = &"res://"
const PREFIX_USER : StringName = &"user://"
const PREFIX_EXEC : StringName = &"exec://"



#region path

static func analyse_path(path : String, mod_path : String = "") -> String:
	if path.begins_with(PREFIX_MOD):
		return mod_path + path.substr(PREFIX_MOD.length())
	elif path.begins_with(PREFIX_EXEC):
		return get_executable_directory() + path.substr(PREFIX_EXEC.length())
	
	return path



static func get_executable_directory() -> String:
	return OS.get_executable_path().get_base_dir() + "/"

static func open_executable_directory() -> DirAccess:
	return open_directory(get_executable_directory())



static func get_user_data_directory() -> String:
	return OS.get_user_data_dir() + "/"

static func open_user_data_directory() -> DirAccess:
	return open_directory(get_user_data_directory())

#endregion



#region file

static func open_readonly_file(path : String) -> FileAccess:
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	if not is_instance_valid(file):
		Logger.loge("Failed to open readonly file: \"%s\", reason: \"%s\"." % [path, error_string(FileAccess.get_open_error())])
	return file



static func open_writeonly_file(path : String) -> FileAccess:
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if not is_instance_valid(file):
		Logger.loge("Failed to open writeonly file: \"%s\", reason: \"%s\"." % [path, error_string(FileAccess.get_open_error())])
	return file



static func open_readwrite_file(path : String, create_if_not_exist : bool = true) -> FileAccess:
	var file : FileAccess = null
	if create_if_not_exist:
		file = FileAccess.open(path, FileAccess.WRITE_READ)
	else:
		file = FileAccess.open(path, FileAccess.READ_WRITE)
	
	if not is_instance_valid(file):
		Logger.loge("Failed to open readwrite file: \"%s\", reason: \"%s\"." % [path, error_string(FileAccess.get_open_error())])
	
	return file



static func get_file_text(path : String, skip_cr: bool = false) -> String:
	var file : FileAccess = open_readonly_file(path)
	if not is_instance_valid(file):
		return ""
	
	return file.get_as_text(skip_cr)

#endregion



#region load json

static func load_json_file(path : String, skip_cr: bool = false) -> Variant:
	var text : String = get_file_text(path, skip_cr)
	
	var json : JSON = JSON.new()
	var err : Error = json.parse(text)
	if err == OK:
		return json.data
	
	Logger.loge("Failed to parse JSON file (\"%s\"), error line: %d, error message: \"%s\"." % [path, json.get_error_line(), json.get_error_message()])
	return null



static func load_json_dictionary(path : String, skip_cr: bool = false) -> Dictionary:
	var data : Variant = load_json_file(path, skip_cr)
	if data is Dictionary:
		return data
	
	Logger.loge("The data in this JSON file (\"%s\") must be a Dictionary, current type: \"%s\"." % [path, type_string(typeof(data))])
	return {}

#endregion



#region directory

static func open_directory(path : String) -> DirAccess:
	var dir : DirAccess = DirAccess.open(path)
	if not is_instance_valid(dir):
		Logger.loge("Failed to open directory: \"%s\", reason: \"%s\"." % [path, error_string(DirAccess.get_open_error())])
	return dir



static func get_files_from_dir(path : String, full : bool = true, reverse : bool = false) -> PackedStringArray:
	if not path.ends_with("/") or path.ends_with("\\"):
		path += "/"
	
	var dir : DirAccess = FilesystemUtilities.open_directory(path)
	if not is_instance_valid(dir):
		return []
	
	var files : PackedStringArray = []
	for filename in dir.get_files():
		files.append(path + filename if full else filename)
	
	if reverse:
		files.reverse()
	
	return files



static func get_dirs_from_dir(path : String, full : bool = true, reverse : bool = false) -> PackedStringArray:
	if not path.ends_with("/") or path.ends_with("\\"):
		path += "/"
	
	var dir : DirAccess = FilesystemUtilities.open_directory(path)
	if not is_instance_valid(dir):
		return []
	
	var dirs : PackedStringArray = []
	for dirname in dir.get_directories():
		dirs.append(path + dirname + "/" if full else dirname + "/")
	
	if reverse:
		dirs.reverse()
	
	return dirs



static func get_all_from_dir(path : String, dirs_first : bool = true, full : bool = true, reverse : bool = false) -> PackedStringArray:
	var dirs : PackedStringArray = get_dirs_from_dir(path, full, reverse)
	var files : PackedStringArray = get_files_from_dir(path, full, reverse)
	
	return dirs + files if dirs_first else files + dirs

#endregion



static func file_extension_filter(source : Array[String], extensions : PackedStringArray) -> PackedStringArray:
	return source.filter(func(filename : String):
		for ext in extensions:
			if filename.ends_with(ext):
				return true
		return false
	)
