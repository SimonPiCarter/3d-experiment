class_name Robot_3 extends IKQuadObject

func get_materials_for_picker() -> Array[ShaderMaterial]:
	return [
		$Armature/Skeleton3D/Body.get_surface_override_material(0) as ShaderMaterial,
		$Armature/Skeleton3D/Legs.get_surface_override_material(0) as ShaderMaterial,
	]
