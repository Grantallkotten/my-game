@tool
extends Node3D

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
	print("Mesh set ", wepon_mesh)
	if WEPON_TYPE:
		wepon_mesh.mesh = WEPON_TYPE.mesh
		position = WEPON_TYPE.position
		rotation_degrees = WEPON_TYPE.rotation
		wepon_mesh.scale = WEPON_TYPE.scale
