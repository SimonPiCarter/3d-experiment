extends Node3D

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_Z:
			$Node3D.position.x += 0.1
		elif event.keycode == KEY_S:
			$Node3D.position.x -= 0.1
