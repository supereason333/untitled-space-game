extends Node3D

var system:GeneratedSystem

var current_planet := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_system(actual_system:GeneratedSystem):
	system = actual_system

func set_star(pos_rel:Vector2):
	pass
