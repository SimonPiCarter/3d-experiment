extends BaseExplosion

@onready var sphere_vfx = $SphereVFX
@onready var sphere_animator: Node3D = $SphereVFX/SphereAnimator

func setup() -> void:
	sphere_vfx.scale = Vector3.ZERO

func fire(delay:float) -> void:
	sphere_animator.vanishing_start = delay+0.2
	sphere_animator.elapsed = -1.
	sphere_animator.running = true
	sphere_vfx.scale = Vector3.ZERO
	sphere_vfx.rotate_y(randf_range(0.,2.*PI))
	var tw = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(sphere_vfx, "scale", Vector3.ONE, 0.1).set_delay(delay+0.1)
