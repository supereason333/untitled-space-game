extends Node2D

@onready var time_selector := $GUI/TimeSelect
var save_path := "res://saver_loader/saves/testworld.tres"

var zoom_scale := Vector2(1, 1)
var centre := Vector2(0, 0)
var panning := false
var system:GeneratedSystem
var orbit_radius_scale := 30

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(save_path):
		system = ResourceLoader.load(save_path)
	$GUI/SeedLabel.text = str(GlobalUtils.main_seed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if delta > 0.01: print_debug(delta)
	if $GUI/DoSpin.button_pressed:
		time_selector.value += $GUI/TimeRateSelect.value

func _on_generate_button_pressed():
	system = GeneratorRoot.generate_system($GUI/IDSpinBox.value, $GUI/SeedSpinBox.value, 0, 0, Vector2(0, 0))
	
	var planets = system.planets.size()
	$GUI/Labels/DataLabels/SystemId.text = str(system.id_in_sector)
	$GUI/Labels/DataLabels/StarType.text = str(GeneratedIDs.STAR_TYPE_STRING[system.star_type])
	$GUI/Labels/DataLabels/StarRadius.text = str(system.star_radius) + " (Solar radius)"
	$GUI/Labels/DataLabels/StarMass.text = str(system.star_mass) + " (Solar mass)"
	$GUI/Labels/DataLabels/Planets.text = str(planets)
	
	$GUI/PlanetSelect.max_value = planets - 1
	$GUI/PlanetSelect.value = 0
	
	queue_redraw()


func _on_seed_spin_box_value_changed(value):
	GlobalUtils.main_seed = value


func _draw():
	if system:
		for i in 20:
			draw_arc(centre, i * orbit_radius_scale * zoom_scale.x * 2, 0, 360, 360, Color(0.35, 0.35, 0.35))
		draw_circle(centre, 7, Color.WHITE)
		for planet in system.planets:
			var rads = 2 * PI * (time_selector.value / (planet.orbital_period / 86400))
			var pos = Vector2(planet.orbital_radius * orbit_radius_scale * sin(rads), planet.orbital_radius * orbit_radius_scale * cos(rads))
			draw_arc(centre, planet.orbital_radius * orbit_radius_scale * zoom_scale.x, 0, 360, 360, Color.DIM_GRAY, 2)
			draw_circle(pos * zoom_scale + centre, 3, Color.WHITE)


func _on_planet_select_value_changed(value):
	if system:
		var planet = system.planets[$GUI/PlanetSelect.value]
		$GUI/PlanetLabels/DataLabels/Radius.text = str(planet.radius)
		$GUI/PlanetLabels/DataLabels/OrbitalRadius.text = str(planet.orbital_radius) + " AU"
		$GUI/PlanetLabels/DataLabels/OrbitalPeriod.text = str(planet.orbital_period / 86400) + " Days"
		$GUI/PlanetLabels/DataLabels/Type.text = str(GeneratedIDs.PLANET_TYPE_STRING[planet.type])
		$GUI/PlanetLabels/DataLabels/Moons.text = str(planet.moons.size())


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if panning:
			centre += event.relative
			queue_redraw()


func _on_time_select_value_changed(value):
	queue_redraw()


func _on_zoom_slider_value_changed(value):
	zoom_scale = Vector2(value, value)
	queue_redraw()


func _on_button_button_down():
	panning = true


func _on_button_button_up():
	panning = false
