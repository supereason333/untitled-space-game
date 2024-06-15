extends Node3D

@onready var sun := $SunLight

func _on_game_change_sun_rotation(rotation):
	sun.rotation = rotation
