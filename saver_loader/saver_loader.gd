extends Node

var save_path := "res://saver_loader/saves/player.tres"

func save_game_player():
	var saved_player = SavedPlayer.new()
	
	var data:Array[SavedPlayer]
	get_tree().call_group("player", "on_player_save", data)
	
	saved_player = data[0]
	ResourceSaver.save(saved_player, save_path)

func load_game_player():
	if !FileAccess.file_exists(save_path):
		print_debug("Tried to load with no player save")
		return
	
	var saved_player = ResourceLoader.load(save_path)
	
	get_tree().call_group("player", "on_player_load", saved_player)

func save_game_world():
	pass
