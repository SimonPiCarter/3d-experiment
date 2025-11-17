class_name QuadEntity extends Node3D

@export var move_speed : float = 3.
@export var turn_speed : float = 1.*PI
@export var step_offset : float = 1.
@onready var marker_container: Node3D = $IKQuadContainer/MarkerContainer

var ref_pos: Vector3
var ref_step_time: float

func _ready():
	ref_pos = marker_container.position
	ref_step_time = $IKQuadContainer.step_time

func _handle_movement(direction: Vector3, delta):
	var length_dir = direction.length()
	if length_dir <= 0.01:
		marker_container.global_position = global_position + ref_pos
		$IKQuadContainer.set_current_speed(Vector3.ZERO)
		return
	var norm_dir = direction / length_dir
	position += norm_dir * move_speed * delta
	var local_dir = $Marker3D.global_position - global_position
	$IKQuadContainer.set_current_speed(norm_dir * move_speed)

	var delta_angle = direction.signed_angle_to(local_dir, Vector3.UP)
	if abs(delta_angle) > 0.01:
		$IKQuadContainer.step_time = ref_step_time / 2.
		$IKQuadContainer.update_step_info()
		marker_container.global_position = global_position + ref_pos
		var max_angle = turn_speed * delta
		rotate_object_local(Vector3.UP, -clamp(delta_angle, -max_angle, max_angle))
	else:
		$IKQuadContainer.step_time = ref_step_time
		$IKQuadContainer.update_step_info()
		marker_container.global_position = global_position + ref_pos + norm_dir * step_offset
	# debug
	if has_node("LocalDir"):
		get_node("LocalDir").global_position = global_position + local_dir.normalized()*5.
	if has_node("MoveDir"):
		get_node("MoveDir").global_position = global_position + direction.normalized()*4.
