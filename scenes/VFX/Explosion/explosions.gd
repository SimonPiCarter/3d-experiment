extends BaseExplosion

func setup() -> void:
	for children in get_children():
		children.scale = Vector3.ZERO

func fire(delay:float) -> void:
	rotate_y(randf_range(0.,2.*PI))
	for children in get_children():
		var tw = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(children, "scale", Vector3.ONE, 0.05).set_delay(delay+0.1+randf_range(0.,0.1))
		tw.tween_property(children, "scale", Vector3.ZERO, 0.1).set_delay(0.05)
