extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.keycode == KEY_W and key_event.is_pressed():
			$MainViewport/SubViewport/Room.spawn()
		if key_event.keycode == KEY_X and key_event.is_pressed():
			$MainViewport/SubViewport/Room.despawn()
