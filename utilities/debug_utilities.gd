class_name DebugUtilities
extends RefCounted



const SCRIPT_REPLACEMENT : StringName = &"REPLACEMENT"
const SCRIPT_FOR_LINE_CODE : StringName = \
&"""
extends RefCounted

func _init() -> void:
	REPLACEMENT
	pass

"""



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



static func run_gdscript_line(line_code : String) -> Error:
	var source_code : String = SCRIPT_FOR_LINE_CODE.replace(SCRIPT_REPLACEMENT, line_code)
	return run_gdscript_string(source_code)
