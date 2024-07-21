extends Node2D

var planet_positions:Array[Vector2]
var zoom := 10.0

var current_system:GeneratedSystem
var current_planet:int

func update_draw():
	draw_system(current_system, current_planet)

func draw_system(system:GeneratedSystem, marked_planet:int):
	current_system = system
	current_planet = marked_planet
	if system:
		planet_positions.clear()
		for planet in system.planets:
			planet_positions.append(Vector2(planet.orbital_radius * sin(planet.current_pos), planet.orbital_radius * cos(planet.current_pos)))
	
	queue_redraw()

func _draw():
	draw_circle(Vector2(0, 0), 4, Color.WHITE)
	for pos in planet_positions:
		draw_circle(pos * zoom, 2, Color.WHITE)
