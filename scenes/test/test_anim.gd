extends Node3D

@onready var animation_tree: AnimationTree = $AnimationTree

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		animation_tree.is_jumping = not animation_tree.is_jumping
		print("is_jumping ", animation_tree.is_jumping)
