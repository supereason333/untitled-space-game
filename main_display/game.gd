extends Node2D

signal place_bg_objects(star_position:Vector2, star_radius:float)
signal change_sun_rotation(rotation:Vector3)

var current_sector:GeneratedSector
var current_system:GeneratedSystem
var current_planet := 0

func _ready():
	enter_system(0, 0, 0)

func enter_system(sector_x:int, sector_y:int, system_id:int):
	if !current_sector:
		current_sector = SaverLoader.load_game_sector(sector_y, sector_x)
	
	if current_sector.sector_x != sector_x or current_sector.sector_y != sector_y:
		current_sector = SaverLoader.load_game_sector(sector_y, sector_x)
	
	current_system = current_sector.systems[clamp(system_id, 0, len(current_sector.systems) - 1)]
	current_planet = 0
	
	var delta_time = Time.get_unix_time_from_system() - current_system.last_visit_time
	
	current_system.planets[current_planet].last_pos += (delta_time / current_system.planets[current_planet].orbital_period) * PI * 2
	current_system.last_visit_time = Time.get_unix_time_from_system()
	
	print(delta_time)
	
	var planet_orbital_radius := current_system.planets[current_planet].orbital_radius
	var planet_position := current_system.planets[current_planet].last_pos
	
	var star_position:Vector2
	star_position = Vector2(planet_orbital_radius * sin(planet_position), planet_orbital_radius * cos(planet_position))
	
	current_sector.systems[system_id] = current_system
	
	SaverLoader.save_game_sector(current_sector)
	
	emit_signal("place_bg_objects", star_position)
	emit_signal("change_sun_rotation", Vector3(0, planet_position, 0))

func goto_planet(planet_id:int):
	current_planet = planet_id

func leave_system():
	pass

func get_info(data):
	data.append(["Star type", current_system.star_type])
	data.append(["Star Radius", current_system.star_radius])
	data.append(["Star Mass", current_system.star_mass])
	data.append(["Star Volume", current_system.star_volume])
	data.append(["System in Sector", str(current_system.system_in_sector_x) + ", " + str(current_system.system_in_sector_y)])
	data.append(["System Position", current_system.position_in_sector])
	data.append(["System ID", current_system.id_in_sector])
	data.append(["Last Visit Time", current_system.last_visit_time])
	data.append(["Planets", len(current_system.planets)])

func get_planet_info(data, planet_id:int):
	pass
