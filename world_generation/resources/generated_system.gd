class_name GeneratedSystem
extends Resource

@export var system_id = 0
@export var star_type := 0		# type of star
@export var star_radius := 0.0	# Radius of star
@export var star_mass := 0.0	# Mass of star in solar mass
@export var star_volume := 0.0 	# volume of the star

@export var planets:Array[GeneratedPlanet]
