extends Node3D

@onready var entity: Node3D = $Entity
@export var move_speed : float = 3.
@export var turn_speed : float = 3.
@onready var marker_container: Node3D = $Entity/IKQuadContainer/MarkerContainer

var ref_pos: Vector3

func _ready():
	ref_pos = marker_container.position

func _physics_process(delta: float) -> void:
	var dir = Input.get_axis('ui_down', 'ui_up')
	entity.translate(Vector3(0, 0, dir) * move_speed * delta)
	entity.translate(Vector3(0, 0, dir) * move_speed * delta)
	if dir > 0:
		marker_container.position.z = ref_pos.z + 1.0
	elif dir < 0:
		marker_container.position.z = ref_pos.z - 1.0
	else:
		marker_container.position.z = ref_pos.z

	var a_dir = Input.get_axis('ui_right', 'ui_left')
	entity.rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)
