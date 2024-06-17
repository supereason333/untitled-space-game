extends RigidBody3D

@onready var player_menu := $PlayerMenu
@onready var player_map := $PlayerMap

var menu_showing := false:
	set(value):
		if menu_showing != value:
			menu_showing = value
			
			if value:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get:
		return menu_showing

var pitch := 0.0
var roll := 0.0
var yaw := 0.0

var roll_agility := 0.5
var agility := 2.0

var max_speed := 10.0
var acceleration := 1.0
var speed := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	check_menu_input()

func check_menu_input():
	if Input.is_action_just_pressed("ui_cancel"):
		menu_showing = !menu_showing
		player_menu.visible = menu_showing
	
	if !player_menu.visible:
		if Input.is_action_just_pressed("map"):			# press tab to go back to last view, tab again to go to main map, tab again to close. Any of the other map keys respond to the shortcut to corrosponding map
			player_map.show_maps()
		
		if Input.is_action_just_pressed("system_map"):
			pass
		
		if Input.is_action_just_pressed("planet_map"):
			pass
		
		if Input.is_action_just_pressed("ui_accept"):
			SaverLoader.load_game_player()

func _physics_process(delta):
	roll = Input.get_axis("fighter_roll_right", "fighter_roll_left")
	
	if Input.is_action_pressed("fighter_accelerate"):
		speed = clamp(speed + acceleration, 0, max_speed)
	elif Input.is_action_pressed("fighter_deacelerate"):
		speed = clamp(speed - acceleration, 0, max_speed)
	
	apply_force(transform.basis.z * -speed)		# moves the ship
	
	apply_torque(transform.basis.z * roll * roll_agility)
	apply_torque(transform.basis.y * pitch)
	apply_torque(transform.basis.x * yaw)
	
	GlobalSignals.emit_signal("camera_rotated", rotation)	# rotates camera in bg scene
	pitch = 0
	yaw = 0

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			pitch = clamp(event.relative.x * -0.1, -agility, agility)
			yaw = clamp(event.relative.y * -0.1, -agility, agility)

func on_player_save(data:Array[SavedPlayer]):
	var saved_player = SavedPlayer.new()
	var pos = GlobalPos.new()
	pos.system_id = 0
	pos.planet_id = 0
	pos.location_on_planet = 0
	pos.scene_pos = position
	pos.scene_rotation = rotation
	
	saved_player.pos = pos
	data.append(saved_player)

func on_player_load(data:SavedPlayer):
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	speed = 0
	pitch = 0
	yaw = 0
	
	position = data.pos.scene_pos
	rotation = data.pos.scene_rotation
