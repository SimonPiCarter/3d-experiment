class_name TwadEntity extends Node3D

@export var twad_object : IKTwadObject
@export var step_distance : float = 1.
@export var step_time : float = 0.075
@export var floor_offset : float = 0.01

@onready var left_ik_marker = $MarkerContainer/LeftIKMarker
@onready var right_ik_marker = $MarkerContainer/RightIKMarker
@onready var left_ik_target = $TargetContainerTwad/LeftIKTarget
@onready var right_ik_target = $TargetContainerTwad/RightIKTarget

func _ready() -> void:
	left_ik_target.step_distance = step_distance
	right_ik_target.step_distance = step_distance
	left_ik_target.step_time = step_time
	right_ik_target.step_time = step_time

	if twad_object:
		twad_object.LeftLeg.target_node = left_ik_target.get_path()
		twad_object.RightLeg.target_node = right_ik_target.get_path()
