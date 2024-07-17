class_name DebugUtilities
extends RefCounted



const COMMAND_QUIT_GAME : StringName = &"quit_game"
const COMMAND_HELP : StringName = &"help"



static func run_gdscript(script : GDScript) -> Error:
	if not is_instance_valid(script):
		push_error("Cannot run an invalid GDScript.")
		return ERR_INVALID_PARAMETER
	
	if not script.can_instantiate():
		push_error("Unable to instantiated script.")
		return ERR_INVALID_PARAMETER
	
	var _object : Object = script.new()
	
	return OK

static func run_gdscript_string(source_code : String) -> Error:
	var script : GDScript = GDScript.new()
	
	script.source_code = source_code
	var err : Error = script.reload()
	if err != OK:
		return err
	
	return run_gdscript(script)

static func run_gdscript_file(path : String) -> Error:
	var file : FileAccess = FilesystemUtilities.open_readonly_file(path)
	if not is_instance_valid(file):
		return FAILED
	
	return run_gdscript_string(file.get_as_text())



static func run_command(command : Array[String]) -> Error:
	if command.is_empty():
		push_error("Command cannot be empty.")
		return ERR_INVALID_PARAMETER
	
	match command[0]:
		COMMAND_QUIT_GAME:
			if command.size() == 1:
				Engine.get_main_loop().quit(0)
			elif command.size() == 2:
				Engine.get_main_loop().quit(int(command[1]))
			else:
				push_error("The command (\"quit_game\") can only have a maximum of 1 parameter.")
				return ERR_INVALID_PARAMETER
		
		COMMAND_HELP:
			if command.size() == 1:
				pass
			elif command.size() == 2:
				pass
			else:
				push_error("The command (\"help\") can only have a maximum of 1 parameter.")
				return ERR_INVALID_PARAMETER
	
	return OK
