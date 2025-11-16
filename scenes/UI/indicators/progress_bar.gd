class_name ProgressBar3D extends Node3D

@export_range(0., 1., 0.05) var ratio : float = 1.
@onready var fill_part : GeometryInstance3D = $FillPart

func _process(_delta):
	pass
	fill_part.material_override.set_shader_parameter("ratio", ratio)
