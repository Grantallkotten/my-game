extends CharacterBody3D

@onready var position_label: Label = $HUD/HUDArea/PositionLabel
@onready var velocity_label: Label = $HUD/HUDArea/VelocityLabel

@export var walk_speed: float = 10.0
@export var walk_acceleration: float = 20.0
@export var jump_strength: float = 5.0
@export var gravity: float = 90.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_player_movment(delta)
	_set_hud() 

func _player_movment(delta: float) -> void:
	var movment_direction := Vector3.ZERO
	# Input.get_axis(A, B) --> A will return 1.0 and B -1.0 
	movment_direction.x = Input.get_axis("move_left", "move_right")
	movment_direction.z = Input.get_axis("move_forward", "move_backwards")
	movment_direction.y = Input.get_action_strength("jump")
	movment_direction = movment_direction.normalized()
	
	velocity.y += movment_direction.y * jump_strength
	velocity = velocity.move_toward(movment_direction * walk_speed, walk_acceleration * delta)
	
	_apply_gravity(delta)
	move_and_slide()
	
func _apply_gravity(delta: float) -> void:
	velocity.y -= gravity * delta

func _set_hud() -> void:
	position_label.text = str(round(position.x * 100)/100.0) + ", " + str(round(position.y * 100)/100.0) + ", " + str(round(position.z * 100)/100.0)
	velocity_label.text = str(round(velocity.x * 100)/100.0) + ", " + str(round(velocity.y * 100)/100.0) + ", " + str(round(velocity.z * 100)/100.0)
