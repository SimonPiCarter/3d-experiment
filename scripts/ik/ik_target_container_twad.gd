class_name TargetContainerTwad extends Node3D

@onready var left_ik_target: IKTarget = $LeftIKTarget
@onready var right_ik_target: IKTarget = $RightIKTarget

@onready var set_ik_target_1 : Array[IKTarget] = [left_ik_target]
@onready var set_ik_target_2 : Array[IKTarget] = [right_ik_target]

# last set
var last_set_ik_target : Array[IKTarget] = []

func _physics_process(_delta: float) -> void:
	# first check set 1
	for ik_target in set_ik_target_1:
		if ik_target.should_step():
			ik_target.step()
			swap_set_ik_target()
			break

	# then check set 2
	for ik_target in set_ik_target_2:
		if ik_target.should_step():
			ik_target.step()
			break

func swap_set_ik_target():
	var tmp = set_ik_target_1
	set_ik_target_1 = set_ik_target_2
	set_ik_target_2 = tmp
