@tool
class_name IKTarget extends Marker3D

@export var step_marker: IKMarker
@export var step_distance: float = 1.0
@export var step_time: float = 0.075

@export var adjacent_target: IKTarget
@export var opposite_target: IKTarget
@export var adjusted_target : bool = false

var is_stepping := false
var has_stepped := false

func should_step() -> bool:
	return !is_stepping \
		&& !adjacent_target.is_stepping \
		&& abs(global_position.distance_to(step_marker.global_position)) > step_distance

func step():
	var target_pos = step_marker.global_position
	if adjusted_target:
		target_pos = step_marker.global_position + 0.9*step_distance*(step_marker.global_position - global_position).normalized()
	var half_way = (global_position + target_pos)/2.
	is_stepping = true
	has_stepped = true

	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", half_way + owner.basis.y, step_time)
	t.tween_property(self, "global_position", target_pos, step_time)
	t.tween_callback(func(): is_stepping = false)
