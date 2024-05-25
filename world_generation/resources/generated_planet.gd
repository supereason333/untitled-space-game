class_name GeneratedPlanet
extends Resource

@export var radius := 0.0				# Radius of the body
@export var orbital_radius := 0.0		# Radius from the center of parent body
@export var orbital_period := 0.0		# orbital period search it up
@export var type := 0					# Type of planet
@export var moon_amount := 0			# amount of moons
@export var mass := 0.0					# mass of planet
@export var volume := 0.0				# Volume of planet

@export var moons:Array[GeneratedMoon]
