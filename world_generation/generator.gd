extends Node3D

var rnd = RandomNumberGenerator.new()
@onready var result_system := $Generated
@onready var base_system := $"BaseSystem"
@onready var base_star := $"BaseSystem/BaseStar"
@onready var base_planet := $"BaseSystem/BaseStar/BasePlanet"
@onready var base_satellite := $"BaseSystem/BaseStar/BasePlanet/BaseSatellite"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_system():
	var system_ID := 0							# the ID of the system (each syhstem have diffrent ID)
	var planet_amount = rnd.randi_range(1, 7)	# rnd amout of planets (change to seed dependent later)
	
	var star = generate_star()
	
	for i in planet_amount:
		star.add_child(generate_planet(i))
	
	return star


func generate_star():
	return base_star.duplicate()


func generate_planet(id: int):					# Generates each planet
	var return_planet = base_planet.duplicate()
	
	var generate_moons = random_from_chance(0.9)
	var generate_satellites = random_from_chance(0.5)		# orbit objects (true means there is false means there isnt)
	var generate_ring = random_from_chance(0.2)				# rings
	
	var orbit_r1 := rnd.randf_range(0.5, 20)		# Mesured in AU
	var orbit_r2 := orbit_r1 * rnd.randf_range(0.95, 1.05) * rnd.randf_range(0.95, 1.05)
	
	# generate size, type, etc
	var planet_type_id := rnd.randi_range(0, 3)	# type of planet 0: rocky, 1: gas giant, 2: gas dwarf, 3: Ice giant (make a scrip that returns planet type on ID)
	var planet_radius := 0 # radius in kilometers
	match planet_type_id:
		0:		# rocky planet / terrestrial (if ur a nerd)
			planet_radius = rnd.randi_range(5000, 10000)	# replace with actual sizes
		1:		# gas giant
			planet_radius = rnd.randi_range(20000, 80000)	# replace with actual sizes
		2:		# gas dward
			planet_radius = rnd.randi_range(10000, 20000)	# replace with actual sizes
		3:		# ice giant
			planet_radius = rnd.randi_range(25000, 50000)	# replace with actual sizes
		_:
			print_debug("Mayday, the random number gen isnt working properly")
	
	# generates moons
	var moon_amount := 0
	if generate_moons:			# Checks if we need other satellites
		moon_amount = rnd.randi_range(1, 5)
		for i in moon_amount:
			return_planet.add_child(generate_satellite(true), planet_radius)
	
	# generate satellites
	var satellite_amount := 0
	if generate_satellites:			# Checks if we need other satellites
		satellite_amount = rnd.randi_range(1, 5)
		for i in satellite_amount:
			return_planet.add_child(generate_satellite(false))
	
	return_planet.planet_id = id
	return_planet.planet_radius = planet_radius
	return_planet.planet_type_id = planet_type_id
	return_planet.orbit_r1 = orbit_r1
	return_planet.orbit_r2 = orbit_r2
	return_planet.display_values()
	return return_planet


func generate_satellite(is_moon: bool, planet_radius: int = 0):			# Generates a satellite type 0 = moon, type 1 = artificial
	var return_satellite = base_satellite.duplicate()
	
	var orbit_r1 := rnd.randf_range(300000, 600000)		# Mesured in km
	var orbit_r2 := orbit_r1 * rnd.randf_range(0.95, 1.05) * rnd.randf_range(0.95, 1.05)
	
	if is_moon:		# Generates a standard moon
		var radius := rnd.randi_range(planet_radius / 10, planet_radius / 4)
		
		return_satellite.radius
	else:			# Some sort of orbiting structure
		pass
	return_satellite.is_moon = is_moon
	return_satellite.orbit_r1 = orbit_r1
	return_satellite.orbit_r2 = orbit_r2
	return return_satellite


func generate_planet_surface():					# land generation so fun im looking fowards to this woo hoo
	pass


func random_from_chance(input: float):			# chooses true/false from a chance. Input = 0.3 -> 30% to return true
	if input < rnd.randf():
		return false
	else:
		return true

