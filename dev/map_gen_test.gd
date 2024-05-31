extends Node2D

var perlin_noise := FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	perlin_noise.noise_type = FastNoiseLite.TYPE_VALUE
	perlin_noise.seed = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(generate_noise_array(1, Vector2(10, 10)))
	pass

func generate_noise_array(seed:int, size:Vector2, scale):
	var values := []
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = seed
	
	for x in size.x:
		values.append(Array())
		for y in size.y:
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

func _on_generate_button_pressed():
	var noise_map = generate_noise_array($SpinBox.value, Vector2(200, 200), 10)
	display_noise(noise_map, 0.1)
