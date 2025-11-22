class_name SimpleRobot extends IKQuadObject

@onready var canon: Marker3D = $Armature/Skeleton3D/Arms/Marker3D

func get_source() -> Vector3:
	return canon.global_position

func get_materials_for_picker() -> Array[ShaderMaterial]:
	return [
		$Armature/Skeleton3D/Arms.get_surface_override_material(0) as ShaderMaterial, 
		$Armature/Skeleton3D/Body.get_surface_override_material(0) as ShaderMaterial,
		$Armature/Skeleton3D/Head.get_surface_override_material(0) as ShaderMaterial,
		$Armature/Skeleton3D/Legs.get_surface_override_material(0) as ShaderMaterial,
	]
