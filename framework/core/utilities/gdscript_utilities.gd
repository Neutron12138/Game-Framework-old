class_name GDScriptUtilities
extends RefCounted



static func check_gdscript(script : GDScript) -> Error:
	if not is_instance_valid(script):
		Logger.loge("Cannot run an invalid GDScript (%s)." % str(script))
		return ERR_INVALID_PARAMETER
	
	if not script.can_instantiate():
		Logger.loge("Unable to instantiated script (%s)." % str(script))
		return ERR_INVALID_PARAMETER
	
	return OK



static func _create_gdobject(script : GDScript) -> Object:
	var object : Object = script.new()
	return object

static func create_gdobject(script : GDScript) -> Object:
	if check_gdscript(script) != OK:
		return null
	
	return _create_gdobject(script)



static func load_gdscript(script : Script) -> Object:
	var object : Object = create_gdobject(script)
	return object



static func load_gdscript_from_string(source_code : String) -> Object:
	var script : GDScript = GDScript.new()
	
	script.source_code = source_code
	var err : Error = script.reload()
	if err != OK:
		return null
	
	return load_gdscript(script)



static func load_gdscript_from_file(path : String, skip_cr : bool = false) -> Object:
	var text : String = FilesystemUtilities.get_file_text(path, skip_cr)
	return load_gdscript_from_string(text)
