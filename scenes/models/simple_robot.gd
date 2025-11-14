class_name SimpleRobot extends IKQuadObject

@onready var canon: Marker3D = $Armature/Skeleton3D/Arms/Marker3D

func get_source() -> Vector3:
	return canon.global_position
