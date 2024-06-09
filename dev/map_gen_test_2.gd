extends Node2D

var noise = FastNoiseLite.new()
var sector_noise = [[]]

var visual_scale = 4

var sector:GeneratedSector
var sector2:GeneratedSector
var sector3:GeneratedSector
var sector4:GeneratedSector

func _ready():
	sector_noise = GeneratorRoot.generate_sector_noise(0, 0, 0)
	sector = GeneratorRoot.generate_sector(0, 0, 0)
	sector2 = GeneratorRoot.generate_sector(1, 0, 0)
	sector3 = GeneratorRoot.generate_sector(0, 1, 0)
	sector4 = GeneratorRoot.generate_sector(1, 1, 0)
	
	SaverLoader.save_game_sector(sector)
	SaverLoader.save_game_sector(sector2)
	SaverLoader.save_game_sector(sector3)
	SaverLoader.save_game_sector(sector4)

"""
func generate_sector(sec_x:int, sec_y:int, seed:int):
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = seed
	var noise_scale = 1
	
	for x in 100:		# 100ly is the size of the sector
		sector_noise.append(Array())
		for y in 100:
			var noise_value = (noise.get_noise_2d( x * noise_scale, y * noise_scale ) + 1) / 2
			sector_noise[x].append(noise_value)
			
	queue_redraw()
"""

func _draw():					# dosent quite work i think 4d array is a little jank
	for x in len(sector_noise):
		for y in len(sector_noise[x]):
			draw_rect(Rect2((x * visual_scale), (y * visual_scale), visual_scale, visual_scale), Color(sector_noise[x][y], sector_noise[x][y], sector_noise[x][y]))
	
	if sector:
		for system in sector.systems:
			var pos = system.position_in_sector * visual_scale
			draw_circle(pos, 3, Color.YELLOW)
	if sector2:
		for system in sector2.systems:
			var pos = system.position_in_sector * visual_scale + Vector2(100, 0) * visual_scale
			draw_circle(pos, 3, Color.BLUE)
	if sector3:
		for system in sector3.systems:
			var pos = system.position_in_sector * visual_scale + Vector2(0, 100) * visual_scale
			draw_circle(pos, 3, Color.BLUE)
	if sector4:
		for system in sector4.systems:
			var pos = system.position_in_sector * visual_scale + Vector2(100, 100) * visual_scale
			draw_circle(pos, 3, Color.YELLOW)
