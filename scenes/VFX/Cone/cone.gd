@tool
class_name Cone extends Node3D

@export_range(0.,1.) var threshold = 0.6
@export var color : Color = Color("d5e04b")
@onready var mesh: MeshInstance3D = $Cone

var old_t : float = 0.
var old_color : Color = Color.WHITE

func _ready():
	mesh.get_surface_override_material(0).set_shader_parameter("ThresholdAlpha", threshold)
	old_t = threshold
	mesh.get_surface_override_material(0).set_shader_parameter("ColorLow", color)
	old_color = color

func _process(delta: float) -> void:
	if threshold != old_t:
		mesh.get_surface_override_material(0).set_shader_parameter("ThresholdAlpha", threshold)
		old_t = threshold

	if color != old_color:
		mesh.get_surface_override_material(0).set_shader_parameter("ColorLow", color)
		old_color = color
