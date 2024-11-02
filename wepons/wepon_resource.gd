extends Resource

class_name Wepons

@export var name: String
@export_category("Wepon Orientation")
@export var position: Vector3
@export var rotation: Vector3
@export var scale: Vector3 = Vector3.ONE
@export_category("Visual Settings")
@export var mesh: Mesh
@export_category("Wepon Atributes")
@export var damage: float
