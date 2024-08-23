class_name GameDataUtilities
extends RefCounted



const GAMESAVE_DIRNAME : StringName = &"saves/"



static func load_save(path : String) -> BasicGameData:
	var game_data : BasicGameData = BasicGameData.Loader.load(path)
	return game_data



static func save_game(game_data : BasicGameData, path : String) -> Error:
	return BasicGameData.Saver.save(game_data, path)
