class_name GeneratedPlanet
extends Resource

@export var radius:float				# Radius of the body
@export var orbital_radius:float		# Radius from the center of parent body
@export var orbital_period:float		# orbital period search it up
@export var type:int					# Type of planet
@export var moon_amount:int				# amount of moons
@export var mass:float					# mass of planet
@export var volume:float				# Volume of planet

@export var last_pos := 0.0				# saved location in orbit in radians around star
@export var current_pos := 0.0			# Current position of planet

@export var moons:Array[GeneratedMoon]
