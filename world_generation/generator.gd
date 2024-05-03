extends Node3D

var rnd = RandomNumberGenerator.new()
@onready var result_system := $Generated
@onready var base_system := $"BaseSystem"
@onready var base_star := $"BaseSystem/BaseStar"
@onready var base_planet := $"BaseSystem/BaseStar/BasePlanet"
@onready var base_satellite := $"BaseSystem/BaseStar/BasePlanet/BaseSatellite"


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_system()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func generate_system():
	var system_ID := 0							# the ID of the system (each syhstem have diffrent ID)
	var planet_amount = rnd.randi_range(1, 5)	# rnd amout of planets (change to seed dependent later)
	
	result_system.add_child(generate_star())
	var star = result_system.get_child(0)
	
	for i in planet_amount:
		star.add_child(generate_planet(i))


func generate_star():
	return Node3D.new()


func generate_planet(id: int):					# Generates each planet
	var return_planet = base_planet.duplicate()
	
	var generate_moons = random_from_chance(0.9)			# Moons (true means there is false means there isnt)
	var generate_other_satellites = random_from_chance(0.3)	# Other satellites
	var generate_ring = random_from_chance(0.4)				# rings
	
	# generate size, type, etc
	var planet_type_id := rnd.randi_range(0, 3)	# type of planet 0: rocky, 1: gas giant, 2: gas dwarf, 3: Ice giant (make a scrip that returns planet type on ID)
	var planet_size := 0 # radius in kilometers
	match planet_type_id:
		0:		# rocky planet / terrestrial (if ur a nerd)
			planet_size = rnd.randi_range(5000, 10000)	# replace with actual sizes
		1:		# gas giant
			planet_size = rnd.randi_range(20000, 80000)	# replace with actual sizes
		2:		# gas dward
			planet_size = rnd.randi_range(10000, 20000)	# replace with actual sizes
		3:		# ice giant
			planet_size = rnd.randi_range(25000, 50000)	# replace with actual sizes
		_:
			print_debug("Mayday, the random number gen isnt working properly")
			
	# generate moons
	if generate_moons:			# Checks if we need moons
		var moon_amount := rnd.randi_range(1, 5)
		for i in moon_amount:
			return_planet.add_child(generate_satellite(0))
			
	# generate satellites
	if generate_other_satellites:			# Checks if we need other satellites
		var satellite_amount := rnd.randi_range(1, 5)
		for i in satellite_amount:
			return_planet.add_child(generate_satellite(1))
			
	# generate other stuff
	
	return_planet.planet_id = id
	return_planet.planet_size = planet_size
	return_planet.planet_type_id = planet_type_id
	return_planet.planet_ring = generate_ring
	return return_planet


func generate_satellite(type: int):				# Generates a satellite type 0 = moon, type 1 = artificial
	return Node3D.new()


func generate_planet_surface():
	pass


func random_from_chance(input: float):			# chooses true/false from a chance. Input = 0.3 -> 30% to return true
	if input < rnd.randf():
		return true
	else:
		return false

