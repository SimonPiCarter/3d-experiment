extends Node3D

func _input(event):
	if event is InputEventKey and event.is_pressed():
		$projectile/AnimationPlayer.play("fire")
		$sphere/AnimationPlayer.play("fire")
