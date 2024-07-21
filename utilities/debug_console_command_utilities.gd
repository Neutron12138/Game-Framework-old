class_name DebugConsoleCommandUtilities
extends RefCounted



const SCRIPT_FUNCNAME : StringName = &"run"
const SCRIPT_REPLACEMENT : StringName = &"REPLACEMENT"
const SCRIPT_FOR_LINE_CODE : StringName = \
&"""
extends RefCounted

var scene_tree : SceneTree = null

func _init(ext : Variant = null) -> void:
	scene_tree = Engine.get_main_loop()

func run() -> void:
	REPLACEMENT
	pass

"""



static func check_gdscript(script : GDScript) -> Error:
	if not is_instance_valid(script):
		push_error("Cannot run an invalid GDScript.")
		return ERR_INVALID_PARAMETER
	
	if not script.can_instantiate():
		push_error("Unable to instantiated script.")
		return ERR_INVALID_PARAMETER
	
	return OK



static func create_gdobject(script : GDScript) -> Object:
	if check_gdscript(script) != OK:
		return null
	
	var object : Object = script.new()
	return object



static func run_gdobject(object : Object) -> Error:
	if not is_instance_valid(object):
		push_error("The object to be executed cannot be a null pointer.")
		return ERR_INVALID_PARAMETER
	
	if object.has_method(SCRIPT_FUNCNAME):
		object.call(SCRIPT_FUNCNAME)
	
	return OK



static func run_gdscript(script : Script) -> Error:
	if check_gdscript(script) != OK:
		return FAILED
	
	var object : Object = create_gdobject(script)
	if not is_instance_valid(object):
		return FAILED
	
	run_gdobject(object)
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
