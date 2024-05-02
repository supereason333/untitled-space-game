extends CharacterBody3D

@onready var camera_pivot := $CameraPivot
@onready var camera_twist := $CameraPivot/CameraTwist
@onready var camera := $CameraPivot/CameraTwist/Camera3D

const SPEED := 5.0
const JUMP_VELOCITY := 4.5
var camera_sensitivity := 0.001

var camera_twist_amount := 0.0
var camera_pivot_amount := 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("plr_jump"):
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("plr_left", "plr_right", "plr_fowards", "plr_backwards")
	var direction = (camera_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/2)
		velocity.z = move_toward(velocity.z, 0, SPEED/2)
	
	move_and_slide()

func _process(_delta):
	camera_pivot.rotate_y(camera_pivot_amount)
	camera_twist.rotate_x(camera_twist_amount)
	camera_twist.rotation.x = clamp(camera_twist.rotation.x, -1.57, 1.57)
	camera_pivot_amount = 0
	camera_twist_amount = 0
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(_event):
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			camera_pivot_amount = clamp( - event.relative.x * camera_sensitivity, -0.3, 0.3)
			camera_twist_amount = clamp( - event.relative.y * camera_sensitivity, -0.3, 0.3)
