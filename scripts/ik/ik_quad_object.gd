class_name IKQuadObject extends Node3D

@export var FrontLeftLeg : IKAutoStart
@export var FrontRightLeg : IKAutoStart
@export var BackLeftLeg : IKAutoStart
@export var BackRightLeg : IKAutoStart
@export var Armature : Node3D

func get_materials_for_picker() -> Array[ShaderMaterial]:
	return []
