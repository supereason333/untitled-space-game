extends Node3D

@onready var star := $StarVisual
@onready var sun := $SunLight

func place_star(star_position:Vector2):
	star.position = Vector3(star_position.x, 0, star_position.y)
	print(star.position)

func place_planet():
	pass

func _on_game_place_bg_objects(star_position):
	place_star(star_position)

func _on_game_change_sun_rotation(rotation):
	sun.rotation = rotation
