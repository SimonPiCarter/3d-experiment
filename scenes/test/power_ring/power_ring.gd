@tool
class_name PowerRing extends Node3D

@export var deg_speed : float = 1.
@export var clockwise : bool = true
@export var color : Color = Color("165a4c")
@export var speed_curve : Curve = null
@export var scale_curve : Curve = null
@export var time : float = 1.

func _ready():
	for children in $Ring.get_children():
		children.get_surface_override_material(0).set_shader_parameter("original_color", color)


var elapsed = 0.
func _process(delta):
	var cur_speed = deg_speed
	elapsed = elapsed + delta
	while elapsed >= time:
		elapsed -= time
	if speed_curve:
		var l = speed_curve.get_value_range()
		var offset = elapsed / time * l
		var val = speed_curve.sample_baked(offset);
		cur_speed = deg_speed * val
	if scale_curve:
		var l = scale_curve.get_value_range()
		var offset = elapsed / time * l
		var val = scale_curve.sample_baked(offset);
		for children in $Ring.get_children():
			children.scale = Vector3(val, val, val)
	if clockwise:
		$Ring.rotate_z(deg_to_rad(cur_speed*delta))
	else:
		$Ring.rotate_z(deg_to_rad(-cur_speed*delta))
