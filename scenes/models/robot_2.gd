class_name Robot2 extends IKQuadObject

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func get_source():
	return $Armature/Skeleton3D/Icosphere/Marker3D.global_position

func power():
	animation_player.play("power")

func attack():
	animation_player.play("attack")
