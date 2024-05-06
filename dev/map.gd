extends Node2D

@onready var star
var rads = 0
var rnd = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$GeneratedSystem.add_child($Generator.generate_system())
	star = $GeneratedSystem.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_circle(Vector2(0, 0), 15, Color.YELLOW)
	for i in star.get_children():
		rads = rnd.randf_range(0, 3.141 * 2)
		var pos := Vector2(i.orbit_r1 * cos(rads) * 20, i.orbit_r1 * sin(rads) * 20)
		draw_arc(Vector2(0, 0), i.orbit_r1 * 20, 0, 3.141 * 2, 360, Color.LIGHT_GRAY, 4)	# draw ark
		draw_circle(pos, 8, Color.BLUE)
		for r in i.get_children():
			rads = rnd.randf_range(0, 3.141 * 2)
			var π = 3.14159
			draw_circle(Vector2(r.orbit_r1 / 15000 * cos(π), r.orbit_r1 / 15000 * cos(π)) + pos, 4, Color.WHITE)
