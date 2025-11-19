class_name Robot2 extends IKQuadObject

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func get_source():
	return $Armature/Skeleton3D/Icosphere/Marker3D.global_position

func power():
	animation_player.play("power")

func attack():
	animation_player.play("attack")

func get_materials_for_picker() -> Array[ShaderMaterial]:
	return [
		$Armature/Skeleton3D/Body.get_surface_override_material(0) as ShaderMaterial,
		$Armature/Skeleton3D/Icosphere.get_surface_override_material(0) as ShaderMaterial,
		$Armature/Skeleton3D/Legs.get_surface_override_material(0) as ShaderMaterial,
	]
