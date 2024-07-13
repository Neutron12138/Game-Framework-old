class_name FilesystemUtilities
extends Node



static var error : Error = OK



static func open_readonly_file(path : String) -> FileAccess:
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	if not is_instance_valid(file):
		error = FileAccess.get_open_error()
		push_error("Failed to open file: \"" + path + "\", reason: \"" +\
		error_string(error) + "\".")
	return file



static func load_json_file(path : String, skip_cr: bool = false) -> Variant:
	var file : FileAccess = open_readonly_file(path)
	if error != OK:
		return null
	
	var json : JSON = JSON.new()
	var err : Error = json.parse(file.get_as_text(skip_cr))
	if err == OK:
		return json.data
	
	push_error("Failed to parse JSON file (\"" + path + "\"), error line: " +\
	str(json.get_error_line()) + ", error message: \"" + json.get_error_message() + "\".")
	error = err
	return null



static func load_json_dictionary(path : String, skip_cr: bool = false) -> Dictionary:
	var data : Variant = load_json_file(path, skip_cr)
	if data is Dictionary:
		return data
	
	push_error("The data in this JSON file (\"" + path +\
	"\") must be a Dictionary, current type: \"" +\
	type_string(typeof(data)) + "\".")
	error = ERR_PARSE_ERROR
	return {}



static func open_directory(path : String) -> DirAccess:
	var dir : DirAccess = DirAccess.open(path)
	if not is_instance_valid(dir):
		error = DirAccess.get_open_error()
		push_error("Failed to open directory: \"" + path + "\", reason: \"" +\
		error_string(error) + "\".")
	return dir
