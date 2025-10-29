extends Node3D

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		$Node3D.fire()
