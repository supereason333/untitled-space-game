extends Node

func _ready():
	#add_sibling.call_deferred(generate_system(0))
	generate_system(0)
	pass

"""
Distances:
	between planets: AU
	between moons: km
Radii:
	Stars: solar radius
	planets: km
	moons: km
Mass:
	Stars: Solar mass
	planet: kg
	moons: kg
"""
								# ["Rocky", "Gas giant", "Gas dwarf", "Ice giant"]
const PLANET_TYPE_RADIUS_RANGE = [[5000, 10000], [20000, 80000], [10000, 20000], [25000, 50000]]		# so [3][0] would get Ice giant min size
								# ["Red giant", "White dwarf", "Neutron star", "Red dwarf"]
const STAR_TYPE_RADIUS_RANGE = [[44.6, 445.6], [0.008, 0.015], [0.0000115, 0.00001437], [0.09, 0.15]]	# max and min radii of stars
const STAR_TYPE_DENSITY = [0.0178314, 600000000, 1000000000000000000, 46824.6]		

var chance_generate_moons := 0.9

var rnd = RandomNumberGenerator.new()


func generate_system(system_id: int):			# Generates a whole new system
	# Adds the system and star
	var system = $BaseSystem.duplicate()
	
	rnd.seed = hash(hash(GlobalUtils.main_seed) + hash(system_id))
	var begin_rnd_state = rnd.state
	system.system_id = system_id
	
	system.star_type = rnd.randi_range(0, 3)			# type of star generated
	system.star_radius = rnd.randf_range(STAR_TYPE_RADIUS_RANGE[system.star_type][0], STAR_TYPE_RADIUS_RANGE[system.star_type][1])
	system.star_mass = GlobalUtils.kilogram_to_solar_mass(GlobalUtils.sphere_volume(GlobalUtils.solar_radius_to_meter(system.star_radius)) * STAR_TYPE_DENSITY[system.star_type])	# Mesured in kg
	
	# Adds the planets
	var planet_amount := 0
	if rnd_from_chance(0.2):					# Generates large system
		planet_amount = rnd.randi_range(7, 12)
		#print_debug("Large system")
	elif rnd_from_chance(0.3):					# Generates an extra small system
		planet_amount = rnd.randi_range(1, 3)
		#print_debug("small system")
	else:													# Regular sized system
		planet_amount = rnd.randi_range(4, 6)
		#print_debug("medium system")
	
	for i in planet_amount:			# how is itnot in a range thing
		system.add_child(generate_planet(GlobalUtils.solar_mass_to_kilogram(system.star_mass)))
	
	# Sorts the planets in order
	# working on it
	
	# output things
	"""print_debug("System seed: " + str(rnd.seed))
	print_debug("Star radius: " + str(system.star_radius))
	print_debug("Star type: " + STAR_TYPE_STRING[system.star_type])
	print_debug("Star Mass: " + str(system.star_mass))
	print_debug("Planet amount: " + str(planet_amount))"""
	
	return system


func generate_planet(parent_body_mass: float):	# Mass in kg
	var planet = $BasePlanet.duplicate()
	planet.type = rnd.randi_range(0, 3)			# sets type of planet
	planet.radius = rnd.randf_range(PLANET_TYPE_RADIUS_RANGE[planet.type][0], PLANET_TYPE_RADIUS_RANGE[planet.type][1])	# generates radii based on planet type
	planet.orbital_radius = rnd.randf_range(0.3, 20)
	planet.orbital_period = sqrt(4 * pow(PI, 2) * pow(GlobalUtils.au_to_meter(planet.orbital_radius), 3) / (GlobalUtils.GRAV_CONST * parent_body_mass))
	"""
	print_debug(str(planet.orbital_period / 86400) + " days orbit period")
	print_debug("Orbital radius : " + str(planet.orbital_radius))
	"""
	
	return planet


func generate_moon():
	pass


func rnd_from_chance(input: float):			# chooses true/false from a chance. Input = 0.3 -> 30% to return true
	if input > rnd.randf(): return false
	else: return true
