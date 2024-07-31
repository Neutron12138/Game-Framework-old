class_name GameDataUtilities
extends RefCounted



const GAMESAVE_DIRNAME : StringName = &"saves/"



static func load_save(path : String) -> GameData:
	var game_data : GameData = GameData.Loader.load(path)
	return game_data



static func save_game(game_data : GameData, path : String) -> Error:
	return GameData.Saver.save(game_data, path)
