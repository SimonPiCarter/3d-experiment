class_name RobotV2 extends Node3D

@export var move_speed: float = 1.5
@export var turn_speed: float = 3
@export var floor_offset: float = 0.05
@onready var marker_container: Node3D = $MarkerContainer
@onready var armature: Node3D = $Armature

var ref_pos: Vector3

@onready var front_left_ik_target: IKTarget = $TargetContainer/FrontLeftIKTarget
@onready var front_right_ik_target: IKTarget = $TargetContainer/FrontRightIKTarget
@onready var back_left_ik_target: IKTarget = $TargetContainer/BackLeftIKTarget
@onready var back_right_ik_target: IKTarget = $TargetContainer/BackRightIKTarget

func _ready():
	ref_pos = marker_container.position

func _physics_process(delta: float) -> void:
	var avg_pos = (front_left_ik_target.global_position + front_right_ik_target.global_position
						+ back_left_ik_target.global_position + back_right_ik_target.global_position) / 4.
	armature.global_position = lerp(armature.global_position, avg_pos, move_speed * delta) \
		+ Vector3(0,floor_offset,0)

	_handle_movement(delta)

func _handle_movement(delta):
	var dir = Input.get_axis('ui_down', 'ui_up')
	translate(Vector3(0, 0, -dir) * move_speed * delta)
	if dir > 0:
		marker_container.position.z = ref_pos.z - 1.0
	elif dir < 0:
		marker_container.position.z = ref_pos.z + 1.0
	else:
		marker_container.position.z = ref_pos.z

	var a_dir = Input.get_axis('ui_right', 'ui_left')
	rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)

func _basis_from_normal(normal: Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)

	result = result.orthonormalized()
	result.x *= scale.x 
	result.y *= scale.y 
	result.z *= scale.z 
	
	return result
