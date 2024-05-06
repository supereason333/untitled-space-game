extends Node

func _ready():
	generate_system()

@onready var output := $Output

var rnd = RandomNumberGenerator.new()

var chance_generate_moons := 0.9

func generate_system():			# Generates a whole new system
	# Adds the system and star
	output.add_child($BaseSystem.duplicate())
	var system = output.get_child(0)
	system.star_type = 0			# type of star generated
	match system.star_type:
		0:
			system.star_radius = 1000000	# idk
		1:
			pass
		2:
			pass
		_:
			pass
	
	# Adds the planets
	var planet_amount := 0
	if GlobalUtils.rnd_from_chance(0.2):					# Generates large system
		planet_amount = rnd.randi_range(7, 12)
		print_debug("Large system")
	elif GlobalUtils.rnd_from_chance(0.3):					# Generates an extra small system
		planet_amount = rnd.randi_range(1, 3)
		print_debug("small system")
	else:													# Regular sized system
		planet_amount = rnd.randi_range(4, 6)
		print_debug("medium system")
	
	for i in planet_amount:
		system.add_child(generate_planet())
	


func generate_planet():
	var planet = $BasePlanet.duplicate()
	planet.type = 0			# sets type of planet
	match planet.type:
		0:
			planet.radius = 100000
		1:
			pass
		2:
			pass
		3:
			pass
		_:
			pass
	return planet


func generate_moon():
	pass
