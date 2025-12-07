@tool
class_name CuveVFX2 extends MeshInstance3D

@export_range(0.,1.) var threshold : float = 0.8
@export var color : Color = Color.AQUA

func _process(_delta: float) -> void:
	get_surface_override_material(0).set_shader_parameter("threshold", threshold)
	get_surface_override_material(0).set_shader_parameter("color", color)
