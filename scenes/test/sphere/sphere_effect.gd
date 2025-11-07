extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		$SubViewportContainer2/SubViewport/SphereVFX/AnimationPlayer.play("test2")
