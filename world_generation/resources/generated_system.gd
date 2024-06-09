class_name GeneratedSystem
extends Resource

@export var star_type:int		# type of star
@export var star_radius:float	# Radius of star
@export var star_mass:float	# Mass of star in solar mass
@export var star_volume:float 	# volume of the star

@export var system_in_sector_x:int
@export var system_in_sector_y:int
@export var position_in_sector:Vector2
@export var system_sector_id:int

@export var planets:Array[GeneratedPlanet]

