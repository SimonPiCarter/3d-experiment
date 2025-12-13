class_name QuadEntity extends Node3D

@export var move_speed : float = 3.
@export var turn_speed : float = 1.*PI
@export var step_offset : float = 1.
@export var quad_object : IKQuadObject = null
@onready var marker_container: Node3D = $IKQuadContainer/MarkerContainer

var ref_pos: Vector3
var ref_step_time: float

var agent_rid: RID = NavigationServer3D.agent_create()
var radius:float = 1.0

func _ready():
	var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
	NavigationServer3D.agent_set_map(agent_rid, default_3d_map_rid)
	NavigationServer3D.agent_set_avoidance_enabled(agent_rid, true)
	NavigationServer3D.agent_set_radius(agent_rid, radius)
	NavigationServer3D.agent_set_position(agent_rid, global_transform.origin)
	NavigationServer3D.agent_set_avoidance_callback(agent_rid, self.on_safe_velocity_computed)

	ref_pos = marker_container.position
	ref_step_time = $IKQuadContainer.step_time

func _exit_tree() -> void:
	if agent_rid.is_valid():
		NavigationServer3D.free_rid(agent_rid)

func on_safe_velocity_computed(safe_velocity: Vector3):
	_real_handle_movement(safe_velocity.limit_length(move_speed * cur_delta))

var cur_delta: float = 1.
func _handle_movement(direction: Vector3, delta):
	if agent_rid.is_valid():
		NavigationServer3D.agent_set_position(agent_rid, global_transform.origin)
	cur_delta = delta
	var length_dir = direction.length()
	if length_dir <= 0.0001:
		marker_container.global_position = global_position + ref_pos
		$IKQuadContainer.set_current_speed(Vector3.ZERO)
		if agent_rid.is_valid():
			NavigationServer3D.agent_set_velocity(agent_rid, Vector3.ZERO)
		return
	var norm_dir = direction / length_dir
	if agent_rid.is_valid():
		NavigationServer3D.agent_set_velocity(agent_rid, norm_dir * move_speed * delta)

func _real_handle_movement(speed: Vector3):
	var local_dir = $Marker3D.global_position - global_position
	$IKQuadContainer.set_current_speed(speed/cur_delta)
	position += speed

	if speed.length() <= 0.0001:
		return

	var delta_angle = speed.signed_angle_to(local_dir, Vector3.UP)
	if abs(delta_angle) > 0.01:
		$IKQuadContainer.step_time = ref_step_time / 2.
		$IKQuadContainer.update_step_info()
		marker_container.global_position = global_position + ref_pos + speed.normalized() * step_offset /2.
		var max_angle = turn_speed * cur_delta
		rotate_object_local(Vector3.UP, -clamp(delta_angle, -max_angle, max_angle))
	else:
		$IKQuadContainer.step_time = ref_step_time
		$IKQuadContainer.update_step_info()
		marker_container.global_position = global_position + ref_pos + speed.normalized() * step_offset
	# debug
	if has_node("LocalDir"):
		get_node("LocalDir").global_position = global_position + local_dir.normalized()*5.
	if has_node("MoveDir"):
		get_node("MoveDir").global_position = global_position + speed.normalized()*4.
