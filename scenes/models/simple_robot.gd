class_name SimpleRobot extends "res://scripts/ik/ik_quad_object.gd"

@onready var canon: Marker3D = $Armature/Skeleton3D/Arms/Marker3D

func get_source() -> Vector3:
	return canon.global_position
