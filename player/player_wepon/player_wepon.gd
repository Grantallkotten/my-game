@tool
extends Node3D

var dummy_bool: bool = false

@export var WEPON_TYPE: Wepons:
	set(value):
		WEPON_TYPE = value
		# If in editor only
		if Engine.is_editor_hint():
			load_wepon()

@onready var wepon_mesh: MeshInstance3D = $WeponMesh
@onready var wepon_collision_shape: CollisionShape3D = $WeponMesh/WeponHitbox/WeponCollisionShape

var mouse_movment: Vector2

func _ready() -> void:
	load_wepon()

func load_wepon() -> void:
	if WEPON_TYPE:
		wepon_mesh.mesh = WEPON_TYPE.mesh
		position = WEPON_TYPE.position
		rotation_degrees = WEPON_TYPE.rotation
		wepon_mesh.scale = WEPON_TYPE.scale
		wepon_collision_shape.shape = WEPON_TYPE.mesh.create_convex_shape()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movment = event.relative
	
	if event.is_action_pressed("swap"):
		temp_func_swap_wepons()


func sway_wepon(delta) -> void:
	mouse_movment = mouse_movment.clamp(WEPON_TYPE.sway_min, WEPON_TYPE.sway_max)
	
	# Lerp wepon poition based on mouse movment
	position.x = lerp(position.x, WEPON_TYPE.position.x - (mouse_movment.x * WEPON_TYPE.sway_amount_position) * delta, WEPON_TYPE.sway_speed_position)
	position.y = lerp(position.y, WEPON_TYPE.position.y - (mouse_movment.y * WEPON_TYPE.sway_amount_position) * delta, WEPON_TYPE.sway_speed_position)

	# Lerp wepon rotation based on mouse movment
	rotation_degrees.x = lerp(rotation_degrees.x, WEPON_TYPE.rotation.x - (mouse_movment.x * WEPON_TYPE.sway_amount_rotation) * delta, WEPON_TYPE.sway_speed_rotation)
	rotation_degrees.y = lerp(rotation_degrees.y, WEPON_TYPE.rotation.y - (mouse_movment.y * WEPON_TYPE.sway_amount_rotation) * delta, WEPON_TYPE.sway_speed_rotation)


func _physics_process(delta: float) -> void:
	sway_wepon(delta)


func _on_wepon_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
			var mesh_instance = body.get_node_or_null("MeshInstance3D") as MeshInstance3D
			set_mesh_color_on_hit(mesh_instance)


func temp_func_swap_wepons() -> void:
	if dummy_bool:
		WEPON_TYPE = load("res://wepons/resources/stick_wepon.tres")
	else:
		WEPON_TYPE = load("res://wepons/resources/brome_wepon.tres")
	load_wepon()
	dummy_bool = !dummy_bool
	print("Swap")


func set_mesh_color_on_hit(mesh_instance: MeshInstance3D) -> void:
	if mesh_instance:
		var random_color = Color(randf(), randf(), randf())
		
		# Get the current material
		var material = mesh_instance.material_override
		if material == null:
			material = mesh_instance.get_active_material(0)
		
		if material and material is StandardMaterial3D:
			material = material.duplicate() as StandardMaterial3D
			mesh_instance.material_override = material
			material.albedo_color = random_color
		else:
			print("No suitable material found to change color.")
	else:
		print("No MeshInstance3D found in enemy character.")
