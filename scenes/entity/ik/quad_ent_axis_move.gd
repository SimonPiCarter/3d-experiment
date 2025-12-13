class_name QuadEntityAxisMove extends QuadEntity

func _physics_process(delta: float) -> void:
	var dir_updown = Input.get_axis('ui_down', 'ui_up')
	var dir_leftright = Input.get_axis('ui_right', 'ui_left')
	_handle_movement(dir_updown * Vector3(1,0,-1) + dir_leftright * Vector3(-1,0,-1), delta)
