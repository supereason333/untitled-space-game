extends Node2D

@onready var generator := $GeneratorRoot
@onready var result_system := $ResultSystem

var system
var orbit_radius_scale := 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_generate_button_pressed():
	if result_system.get_child_count() != 0:
		for i in result_system.get_children():
			i.queue_free()
	result_system.add_child(generator.generate_system($GUI/IDSpinBox.value))
	system = result_system.get_child(0)
	
	var planets = system.get_child_count()
	$GUI/Labels/DataLabels/SystemId.text = str(system.system_id)
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
	draw_circle(Vector2(0, 0), 15, Color.WHITE)
	if system:
		for node in system.get_children():
			var pos = Vector2(node.orbital_radius * orbit_radius_scale, 0)
			draw_arc(Vector2(0, 0), node.orbital_radius * orbit_radius_scale, 0, 360, 360, Color.DIM_GRAY, 2)
			draw_circle(pos, 3, Color.WHITE)


func _on_planet_select_value_changed(value):
	system = result_system.get_child(0)
	if system:
		var planet = system.get_child($GUI/PlanetSelect.value)
		$GUI/PlanetLabels/DataLabels/Radius.text = str(planet.radius)
		$GUI/PlanetLabels/DataLabels/OrbitalRadius.text = str(planet.orbital_radius) + " AU"
		$GUI/PlanetLabels/DataLabels/OrbitalPeriod.text = str(planet.orbital_period) + " Days"
		$GUI/PlanetLabels/DataLabels/Type.text = str(GeneratedIDs.PLANET_TYPE_STRING[planet.type])
