extends CharacterBody3D

@onready var position_label: Label = $HUD/HUDArea/PositionLabel
@onready var fps_label: Label = $HUD/HUDArea/FPSLabel


@onready var camera: Camera3D = $CameraPivot/PitchPivot/Camera3D
@onready var camera_pivot: Node3D = $CameraPivot

@export_range(0.0, 1.0) var mouse_sensitivity: float = 0.25


@export var walk_speed: float = 10.0
@export var walk_acceleration: float = 20.0
@export var jump_strength: float = 20.0
@export var gravity: float = 90.0

var camera_input_dirction: Vector2 = Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void:
	var camera_in_motion := (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if camera_in_motion:
		camera_input_dirction = event.screen_relative * mouse_sensitivity
		
func _physics_process(delta: float) -> void:
	var camera_pivot_x_upper_limit: float = PI / 12.0
	var camera_pivot_x_lower_limit: float = - PI / 6.0

	camera_pivot.rotation.x += camera_input_dirction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, camera_pivot_x_lower_limit, camera_pivot_x_upper_limit)
	
	camera_pivot.rotation.y += -camera_input_dirction.x * delta
	camera_input_dirction = Vector2.ZERO

func _process(delta: float) -> void:
	_player_movment(delta)
	_set_hud(delta) 
	
	if Input.is_action_just_pressed("restart"):
		restart_scene()

func _player_movment(delta: float) -> void:
	var movment_direction: Vector3 = Vector3.ZERO
	var forward = camera.global_basis.z
	var right = camera.global_basis.x
	
	# Input.get_axis(A, B) --> A will return 1.0 and B -1.0 
	movment_direction.x = Input.get_axis("move_left", "move_right")
	movment_direction.z = Input.get_axis("move_forward", "move_backwards")
	movment_direction = forward * movment_direction.z + right * movment_direction.x
	movment_direction = movment_direction.normalized()
	

	velocity = velocity.move_toward(movment_direction * walk_speed, walk_acceleration * delta)
	
	var is_about_to_jump = Input.is_action_just_pressed("jump") and is_on_floor()
	if is_about_to_jump:
		velocity.y += jump_strength
	
	_apply_gravity(delta)
	move_and_slide()
	
func _apply_gravity(delta: float) -> void:
	velocity.y -= gravity * delta

func restart_scene():
	get_tree().reload_current_scene()

func _set_hud(delta) -> void:
	position_label.text = str(round(position.x * 100)/100.0) + ", " + str(round(position.y * 100)/100.0) + ", " + str(round(position.z * 100)/100.0)
	fps_label.text = str(round(1/delta)) + " fps"
