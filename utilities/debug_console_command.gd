class_name DebugConsoleCommand
extends RefCounted



const COMMAND_CHANGE_SCENE : StringName = &"change_scene"



var debug_console : VBoxContainer = null



func _init(dc : VBoxContainer) -> void:
	debug_console = dc



func execute_string(string : String) -> void:
	if string.is_empty():
		return
	
	var command : PackedStringArray = string.split(" ")
	execute_command(command)



func execute_command(command : PackedStringArray) -> void:
	if command.is_empty():
		return
	
	var cmd : String = command[0]
	match cmd:
		COMMAND_CHANGE_SCENE:
			var result : String = error_string(DebugConsoleCommand.change_scene(command.slice(1)))
			debug_console.log(result)
		_:
			debug_console.log("Unknown command: \"" + cmd + "\".")



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
	
	SceneTreeUtilities.change_to_new_scene(scene)
	
	return OK
