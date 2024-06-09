extends Node2D

var perlin_noise := FastNoiseLite.new()
var positions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	perlin_noise.noise_type = FastNoiseLite.TYPE_VALUE
	perlin_noise.seed = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_noise_array(seed:int, size:Vector2, scale:float):
	var values := [[]]
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = seed
	
	for x in int(size.x):
		values.append(Array())
		for y in int(size.y):
			values[x].append(noise.get_noise_2d(x * scale, y * scale))
	
	return values

func display_noise(actual_thing, threshold:float):
	for child in $NoiseBackground.get_children():
		child.queue_free()
	
	for x in len(actual_thing):
		for y in len(actual_thing[x]):
			if (actual_thing[x][y] + 1) / 2 < threshold:
				var pixel = $Pixel.duplicate()
				pixel.position = Vector2(x, y) * $Pixel.scale.x
				pixel.modulate = Color((actual_thing[x][y] + 1) / 2, (actual_thing[x][y] + 1) / 2, (actual_thing[x][y] + 1) / 2)
				$NoiseBackground.add_child(pixel)

func generate_map(size:Vector2, centre:Vector2, seed:int):
	var scatter := 0.1
	var rnd := RandomNumberGenerator.new()
	rnd.seed = seed
	var noise_map = generate_noise_array(seed, size, 50)
	var locations:Array[Vector2]
	for x in len(noise_map) - 1:
		for y in len(noise_map[x]) - 1:
			if (noise_map[x][y] + 1) / 2 < 0.15:
				locations.append(Vector2(x + rnd.randfn(0, scatter), y + rnd.randfn(0, scatter)))
				
	return locations

func _on_generate_button_pressed():
	#var noise_map = generate_noise_array($SpinBox.value, Vector2(150, 100), 50)
	positions = generate_map(Vector2(700, 500), Vector2(0, 0), $SpinBox.value)
	#display_noise(noise_map, 1)
	queue_redraw()

func _draw():
	for system in positions:
		draw_circle(system * 5, 2, Color.WHITE)
