@tool
class_name SphereVFX extends Node3D

@export_range(0.,1.) var alpha : float = 0.7

@export var color_high : Color = Color.BLUE
@export var color_low : Color = Color.RED
@export_range(0.,1.) var threshold : float = 0.8
@export var noise : Texture2D = null
@export var is_dirty : bool = true

@onready var sphere: MeshInstance3D = $sphere
@onready var sphere_2: MeshInstance3D = $sphere2

func set_up_shaders(mesh : MeshInstance3D, front:bool):
	var new_low : Color
	var new_high : Color
	if front:
		new_low = color_low * Color(1.,1.,1.,1.);
		new_high = color_high * Color(1.,1.,1.,0.);
	else :
		new_low = color_low * Color(1.,1.,1.,alpha);
		new_high = color_high * Color(1.,1.,1.,alpha);
	mesh.get_surface_override_material(0).set_shader_parameter("ColorLow", new_low)
	mesh.get_surface_override_material(0).set_shader_parameter("ColorHigh", new_high)
	mesh.get_surface_override_material(0).set_shader_parameter("Threshold", threshold)
	mesh.get_surface_override_material(0).set_shader_parameter("Noise", noise)

func _ready():
	set_up_shaders(sphere, false)
	set_up_shaders(sphere_2, true)
	is_dirty = false

func _process(delta: float) -> void:
	set_up_shaders(sphere, false)
	set_up_shaders(sphere_2, true)
	if is_dirty:
		is_dirty = false
