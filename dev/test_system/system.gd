extends Node3D

@onready var generator = $Generator
@onready var system_model = $SystemModel
@onready var small_ball = $BallSmall
@onready var ball = $Ball

# Called when the node enters the scene tree for the first time.
func _ready():
	system_model.add_child(generator.generate_system())
	
	for i in system_model.get_child(0).get_children():
		for r in i.get_children():
			r.add_child(small_ball.duplicate())
			r.position.x = r.orbit_r1 / 1000000
		i.add_child(ball.duplicate())
		i.position.z = i.orbit_r1 / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
