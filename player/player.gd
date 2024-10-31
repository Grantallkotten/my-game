extends RigidBody3D

@onready var label: Label = $HUD/HUTArea/Label

@onready var walk_strength: float = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_movment(delta)
	set_hud() 

func player_movment(delta: float) -> void:
	var input := Vector3.ZERO
	# Input.get_axis(A, B) --> A will return 1.0 and B -1.0 
	input.x = Input.get_axis("ui_left", "ui_right")
	input.z = Input.get_axis("ui_up", "ui_down")
	input.y = Input.get_action_strength("ui_accept")
	
	apply_central_force(input * walk_strength * delta)
	
	
func set_hud() -> void:
	label.text = str(round(position.y * 100)/100.0)
