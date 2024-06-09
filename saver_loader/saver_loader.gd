extends Node

var save_path := "res://saver_loader/saves"

func save_game_player():
	var saved_player = SavedPlayer.new()
	
	var data:Array[SavedPlayer]
	get_tree().call_group("player", "on_player_save", data)
	
	saved_player = data[0]
	ResourceSaver.save(saved_player, save_path + "/player.tres")

func load_game_player():
	if !FileAccess.file_exists(save_path + "/player.tres"):
		print_debug("Tried to load with no player save")
		return
	
	var saved_player = ResourceLoader.load(save_path + "/player.tres")
	
	get_tree().call_group("player", "on_player_load", saved_player)

func save_game_world():
	pass

func save_game_sector(sector:GeneratedSector):
	var name := "sector_" + str(sector.sector_x) + "_" + str(sector.sector_y) + ".tres"		# makes the name "sector_x_y.tres"
	print(save_path + "/world/" + name)
	ResourceSaver.save(sector, save_path + "/world/" + name)

func save_game_state():
	pass
