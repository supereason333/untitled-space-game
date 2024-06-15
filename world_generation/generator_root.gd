extends Node

func _ready():
	#add_sibling.call_deferred(generate_system(0))
	#generate_save_system("res://saver_loader/saves/testworld.tres", 0)
	#for i in 10:
	#	generate_system(i)
	pass

"""
Distances:
	between planets: AU
	between moons: km
	between stars: ly
Radii:
	Stars: solar radius
	planets: km
	moons: km
Mass:
	Stars: Solar mass
	planet: kg
	moons: kg
Density:
	all: kg/m^3
volume:
	all: m^3
"""

								# ["Rocky", "Gas giant", "Gas dwarf", "Ice giant"]
const PLANET_TYPE_RADIUS_RANGE = [[5000, 10000], [20000, 80000], [10000, 20000], [25000, 50000]]		# so [3][0] would get Ice giant min size
const PLANET_TYPE_DENSITY = [5500, 1200, 2000, 2500]	# ice giant density is a guess
								# ["Red giant", "White dwarf", "Neutron star", "Red dwarf"]
const STAR_TYPE_RADIUS_RANGE = [[44.6, 220], [0.008, 0.015], [0.0000115, 0.00001837], [0.09, 0.15]]	# max and min radii of stars
const STAR_TYPE_DENSITY = [0.00118314, 600000000, 1000000000000000000, 46824.6]

var chance_generate_moons := 0.9

var rnd = RandomNumberGenerator.new()
var rnd_p = RandomNumberGenerator.new()
var rnd_map = RandomNumberGenerator.new()
"""
func generate_save_system(system_id: int, save_path: String):
	var system = generate_system(system_id, GlobalUtils.main_seed)
	
	ResourceSaver.save(system, save_path)
	
	return system
"""

func generate_system(id_in_sector: int, seed:int, sector_x:int, sector_y:int, pos_in_sector:Vector2):			# Generates a whole new system
	# Adds the system and star
	var system := GeneratedSystem.new()
	
	rnd.seed = hash(hash(seed) + hash(str(sector_x) + str(sector_y)) + hash(id_in_sector))
	var begin_rnd_state = rnd.state
	system.id_in_sector = id_in_sector
	system.system_in_sector_x = sector_x
	system.system_in_sector_y = sector_y
	system.position_in_sector = pos_in_sector
	
	system.last_visit_time = Time.get_unix_time_from_system()
	
	var chance = rnd.randf()		# take a chance
	if chance < 0.1:
		system.star_type = 0
	elif chance < 0.3:
		system.star_type = 1
	elif chance < 0.5:
		system.star_type = 2
	else:
		system.star_type = 3
	system.star_radius = rnd.randf_range(STAR_TYPE_RADIUS_RANGE[system.star_type][0], STAR_TYPE_RADIUS_RANGE[system.star_type][1])
	system.star_volume = GlobalUtils.sphere_volume(GlobalUtils.solar_radius_to_meter(system.star_radius))
	system.star_mass = GlobalUtils.kilogram_to_solar_mass(system.star_volume * STAR_TYPE_DENSITY[system.star_type])	# Mesured in solar mass
	
	# Adds the planets
	var planet_amount := 0
	chance = rnd.randf()		# take another chance
	if chance < 0.05:	# extra large system
		planet_amount = int(rnd.randfn(20, 8))
	elif chance < 0.1:	# large system
		planet_amount = int(rnd.randfn(10, 4))
	elif chance < 0.5:	# extra small
		if rnd.randf() < 0.1:
			planet_amount = 1
		else:
			planet_amount = int(rnd.randfn(3, 1))
	else:
		planet_amount = int(rnd.randfn(5, 3))
	
	if planet_amount < 1:
		planet_amount = 1
	
	var planet_group_count := int(round(rnd.randi_range(1, int(planet_amount / 3))))
	if planet_group_count < 1: planet_group_count = 1
	
	var planet_groups = []		# makes planet groups that spawn roughly together
	planet_groups.resize(planet_group_count)
	planet_groups.fill(0)
	
	for i in planet_amount:		# makes the amount of planets in each group random
		planet_groups[rnd.randi_range(0, planet_groups.size() - 1)] += 1
	
	var planet_id := 0
	for i in planet_groups:		# changes orbital radius and spread of each planet group
		var ave_dist := 0.0
		var spread := 0.0
		chance = rnd.randi()
		if chance < 0.03:		# very far group
			ave_dist = rnd.randfn(40, 20)
		elif chance < 0.15:		# far group
			ave_dist = rnd.randfn(17, 12)
		elif chance < 0.19:		# very close group
			ave_dist = rnd.randfn(0.5, 0.2)
		elif chance < 0.4:		# close group
			ave_dist = rnd.randfn(1, 0.6)
		else:					# ave group
			ave_dist = rnd.randfn(4, 3)
		spread = ave_dist / 1.5
		
		for r in i:
			system.planets.append(generate_planet(system.star_mass, planet_id, ave_dist, rnd.seed, spread))
			planet_id += 1
	# Sorts the planets in order
	# working on it
	
	# output things
	"""print_debug("System seed: " + str(rnd.seed))
	print_debug("Star radius: " + str(system.star_radius))
	print_debug("Star type: " + STAR_TYPE_STRING[system.star_type])
	print_debug("Star Mass: " + str(system.star_mass))
	print_debug("Planet amount: " + str(planet_amount))"""
	
	return system


func generate_planet(parent_body_mass: float, planet_id: int, mean_dist: float, seed:int, spread: float = 1):
	rnd_p.seed = hash(hash(planet_id) + hash(seed))
	var begin_state = rnd_p.state
	
	var planet := GeneratedPlanet.new()
	var moon_mult := 1.0
	
	planet.type = rnd_p.randi_range(0, 3)			# sets type of planet
	planet.radius = rnd_p.randf_range(PLANET_TYPE_RADIUS_RANGE[planet.type][0], PLANET_TYPE_RADIUS_RANGE[planet.type][1])	# generates radii based on planet type
	planet.orbital_radius = abs(rnd_p.randfn(mean_dist, spread))
	planet.orbital_period = sqrt(4 * pow(PI, 2) * pow(GlobalUtils.au_to_meter(planet.orbital_radius), 3) / (GlobalUtils.GRAV_CONST * GlobalUtils.solar_mass_to_kilogram(parent_body_mass)))
	planet.volume = GlobalUtils.sphere_volume(planet.radius)
	planet.mass = planet.volume * PLANET_TYPE_DENSITY[planet.type]
	
	planet.last_pos = rnd_p.randf_range(0, PI * 2)
	
	moon_mult = planet.radius / 3000
	if rnd_from_chance(chance_generate_moons):
		planet.moon_amount = int(rnd_p.randfn(5 * moon_mult, 1))
		if planet.moon_amount < 0:
			planet.moon_amount = 0
	else:
		planet.moon_amount = 0
	
	for i in planet.moon_amount:
		planet.moons.append(generate_moon(false, planet.mass))
	
	"""
	print_debug(str(planet.orbital_period / 86400) + " days orbit period")
	print_debug("Orbital radius : " + str(planet.orbital_radius))
	"""
	
	return planet


func generate_moon(big_moon: bool, parent_body_mass: float):
	var moon := GeneratedMoon.new()
	return moon

func scatter_array(input, amount: int):
	for i in amount:
		var a = rnd.randi_range(0, input.size() - 1)
		var b = rnd.randi_range(0, input.size() - 1)
		if input[a] - 1 >= 1:
			input[a] -= 1
			input[b] += 1
	return input

func rnd_from_chance(input: float):			# chooses true/false from a chance. Input = 0.3 -> 30% to return true
	if input < rnd.randf(): return false
	else: return true

var noise := FastNoiseLite.new()
var sec_rnd := RandomNumberGenerator.new()
var noise_scale := 10.0

func generate_sector(sec_x:int, sec_y:int, seed:int):	# Generates a sector Each sector is 100ly * 100ly. stars are --> SHOULD roughly be 5ly apart. X and Y tells you which sector it is
														# The sector's origin on the BOTTOM LEFT it is the "sec_x" and "sec_y" i keep typing "sex_x"
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	var sector := GeneratedSector.new()
	sec_rnd.seed = seed
	noise.seed = seed
	var sector_size := 100 		# Just for clarity, this NEVER changes or i cry then the math gets screwed
	var gen_threshold := 0.89
	
	var base_x := 100 * sec_x * noise_scale
	var base_y := 100 * sec_y * noise_scale
	
	var current_id := 0
	
	sector.sector_x = sec_x
	sector.sector_y = sec_y
	
	for x in sector_size:
		for y in sector_size:
			var noise_data := (noise.get_noise_2d(x * noise_scale + base_x, y * noise_scale + base_y) + 1.0) / 2.0
			if noise_data > gen_threshold:		# then it generates a system there
				var pos := Vector2(x * sec_rnd.randfn(1, 0.01), y * sec_rnd.randfn(1, 0.01))
				var system:GeneratedSystem = generate_system(current_id, seed, sec_x, sec_y, pos)
				current_id += 1
				
				sector.systems.append(system)
				
	return sector

func generate_sector_noise(sec_x:int, sec_y:int, seed:int):
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	var sector_noise = []
	
	for x in 100:
		sector_noise.append(Array())
		for y in 100:
			var noise_data := (noise.get_noise_2d(x * noise_scale + 100 * sec_x * noise_scale, y * noise_scale + 100 * sec_y * noise_scale) + 1.0) / 2.0
			sector_noise[x].append(noise_data)
			
	return sector_noise
