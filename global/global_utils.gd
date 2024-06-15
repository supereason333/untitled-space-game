extends Node

const GRAV_CONST := 0.0000000000667408

var rnd = RandomNumberGenerator.new()
var main_seed := 0


func _ready():
	pass


func au_to_kilometer(distance: float):
	return distance * 149597870


func au_to_meter(distance: float):
	return distance * 149597870000


func solar_radius_to_kilometer(distance: float):
	return distance * 695700


func solar_radius_to_meter(distance: float):
	return distance * 695700000


func kilogram_to_solar_mass(mass: float):
	return mass / (1.989 * pow(10, 30))


func solar_mass_to_kilogram(mass: float):
	return mass * (1.989 * pow(10, 30))


func sphere_volume(radius: float):
	return 4.0 / 3.0 * (radius ** 3) * PI
