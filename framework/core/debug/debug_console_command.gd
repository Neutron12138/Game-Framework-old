class_name DebugConsoleCommand
extends RefCounted



const SCRIPT_REPLACEMENT : StringName = &"REPLACEMENT"
const SCRIPT_FOR_LINE_CODE : StringName = \
&"""
extends RefCounted

var scene_tree : SceneTree = null
var window : Window = null

func _init(ext : Variant = null) -> void:
	scene_tree = Engine.get_main_loop()
	window = scene_tree.root
	
	REPLACEMENT

"""

const COMMAND_CHANGE_SCENE : StringName = &"change_scene"
const COMMAND_GD : StringName = &"gd"
const COMMAND_SCRIPT : StringName = &"script"



var debug_console : Node = null



func _init(dc : Node) -> void:
	debug_console = dc



func execute_string(string : String) -> void:
	if string.is_empty():
		return
	
	var command : PackedStringArray = string.split(" ", false)
	execute_command(command)



func execute_command(command : PackedStringArray) -> void:
	if command.is_empty():
		return
	
	var cmd : String = command[0]
	if cmd.is_empty():
		return
	
	var args : PackedStringArray = command.slice(1)
	
	var result : String = ""
	
	match cmd:
		COMMAND_CHANGE_SCENE:
			result = error_string(DebugConsoleCommand.change_scene(args))
		COMMAND_GD:
			result = error_string(DebugConsoleCommand.gd(args[0]))
		_:
			result = "Unknown command: \"%s\"." % cmd
	
	debug_console.log(result)



static func change_scene(args : PackedStringArray) -> Error:
	if args.size() != 1:
		return ERR_INVALID_PARAMETER
	
	var path : String = args[0]
	var res : Resource = ResourceLoader.load(path)
	
	var scene : Node = null
	if res is PackedScene:
		if not res.can_instantiate():
			return ERR_INVALID_PARAMETER
		scene = res.instantiate()
		
	elif res is GDScript:
		if not res.can_instantiate():
			return ERR_INVALID_PARAMETER
		scene = res.new()
		
	else:
		return ERR_INVALID_PARAMETER
	
	return OK



static func gd(line_code : String) -> Error:
	var source_code : String = SCRIPT_FOR_LINE_CODE.replace(SCRIPT_REPLACEMENT, line_code)
	var object : Object = GDScriptUtilities.load_gdscript_from_string(source_code)
	if not is_instance_valid(object):
		return ERR_INVALID_PARAMETER
	
	return OK
