class_name QuadEntity extends Node3D

@export var move_speed : float = 3.
@export var turn_speed : float = 3.
@export var step_offset : float = 1.
@onready var marker_container: Node3D = $IKQuadContainer/MarkerContainer

var ref_pos: Vector3

func _ready():
	ref_pos = marker_container.position

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _handle_movement(delta):
	var dir = Input.get_axis('ui_down', 'ui_up')
	translate(Vector3(0, 0, dir) * move_speed * delta)
	translate(Vector3(0, 0, dir) * move_speed * delta)
	if dir > 0:
		marker_container.position.z = ref_pos.z + step_offset
	elif dir < 0:
		marker_container.position.z = ref_pos.z - step_offset
	else:
		marker_container.position.z = ref_pos.z

	var a_dir = Input.get_axis('ui_right', 'ui_left')
	rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)
