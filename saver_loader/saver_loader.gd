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

func save_game_sector(sector:GeneratedSector):
	ResourceSaver.save(sector, save_path + "/world/" + get_sector_file_name(sector.sector_x, sector.sector_y))

func load_game_sector(sector_x:int, sector_y:int):
	var sector:GeneratedSector
	if sector_save_exists(sector_x, sector_y):
		sector = ResourceLoader.load(save_path + "/world/" + get_sector_file_name(sector_x, sector_y))
	else:		# generate_new
		print_debug("Loading sector " + str(sector_x) + ", " + str(sector_y) + " but it does not exist so generated new sector.")
		sector = GeneratorRoot.generate_sector(sector_x, sector_y, GlobalUtils.main_seed)
	
	save_game_sector(sector)
	return sector

func sector_save_exists(sector_x:int, sector_y:int):		# does a sector save exist
	if FileAccess.file_exists(save_path + "/world/" + get_sector_file_name(sector_x, sector_y)):
		return true
	else:
		return false

func get_sector_file_name(sector_x:int, sector_y:int): 			# makes the name "sector_x_y.tres"
	return "sector_" + str(sector_x) + "_" + str(sector_y) + ".tres"

func save_game_misc():
	pass
