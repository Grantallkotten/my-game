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

func _ready() -> void:
	load_wepon()

func load_wepon() -> void:
	if WEPON_TYPE:
		wepon_mesh.mesh = WEPON_TYPE.mesh
		position = WEPON_TYPE.position
		rotation_degrees = WEPON_TYPE.rotation
		wepon_mesh.scale = WEPON_TYPE.scale


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swap"):
		if dummy_bool:
			WEPON_TYPE = load("res://wepons/resources/stick_wepon.tres")
		else:
			WEPON_TYPE = load("res://wepons/resources/brome_wepon.tres")
		load_wepon()
		dummy_bool = !dummy_bool
