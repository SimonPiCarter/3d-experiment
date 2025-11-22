class_name IKQuadController extends Node3D

@export var quad_object : IKQuadObject
@export var step_distance : float = 1.
@export var step_time : float = 0.075
@export var floor_offset : float = 0.01
@onready var front_left_ik_marker: IKMarker = $MarkerContainer/FrontLeftIKMarker
@onready var front_right_ik_marker: IKMarker = $MarkerContainer/FrontRightIKMarker
@onready var back_left_ik_marker: IKMarker = $MarkerContainer/BackLeftIKMarker
@onready var back_right_ik_marker: IKMarker = $MarkerContainer/BackRightIKMarker

@onready var front_left_ik_target: IKTarget = $TargetContainer/FrontLeftIKTarget
@onready var front_right_ik_target: IKTarget = $TargetContainer/FrontRightIKTarget
@onready var back_left_ik_target: IKTarget = $TargetContainer/BackLeftIKTarget
@onready var back_right_ik_target: IKTarget = $TargetContainer/BackRightIKTarget

var floor_offset_ref : float = 0.

func set_current_speed(current_speed:Vector3):
	front_left_ik_target.current_speed = current_speed
	front_right_ik_target.current_speed = current_speed
	back_left_ik_target.current_speed = current_speed
	back_right_ik_target.current_speed = current_speed

func update_step_info():
	front_left_ik_target.step_distance = step_distance
	front_right_ik_target.step_distance = step_distance
	back_left_ik_target.step_distance = step_distance
	back_right_ik_target.step_distance = step_distance
	front_left_ik_target.step_time = step_time
	front_right_ik_target.step_time = step_time
	back_left_ik_target.step_time = step_time
	back_right_ik_target.step_time = step_time

func _ready() -> void:
	update_step_info()

	if quad_object:
		quad_object.FrontLeftLeg.target_node = front_left_ik_target.get_path()
		quad_object.FrontRightLeg.target_node = front_right_ik_target.get_path()
		quad_object.BackLeftLeg.target_node = back_left_ik_target.get_path()
		quad_object.BackRightLeg.target_node = back_right_ik_target.get_path()

		floor_offset_ref = quad_object.Armature.global_position.y

var elapsed = randf_range(0,1)
var cycle = 1.
var amplitude = 0.005

func _physics_process(delta: float) -> void:
	var armature = quad_object.Armature
	elapsed += delta
	while elapsed > cycle: elapsed -= cycle
	var cur_offset = cos(elapsed/cycle*2*PI) * amplitude
	armature.global_position.y = floor_offset_ref+cur_offset

func avg_leg_pos() -> Vector3:
	return (front_left_ik_target.global_position + front_right_ik_target.global_position
						+ back_left_ik_target.global_position + back_right_ik_target.global_position) / 4.
