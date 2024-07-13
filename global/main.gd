class_name Main
extends SceneTree



func _initialize() -> void:
	var translations : Array[Translation] = TranslationUtilities.load_translations_from_dir(TranslationUtilities.TRANSLATION_DIRECTORY_PATH)
	TranslationUtilities.add_translations(translations)
	
	auto_accept_quit = false
