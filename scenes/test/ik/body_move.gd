@tool
extends Node3D

@onready var robot_2: Robot2 = $robot2
@onready var armature: Node3D = $robot2/Armature
@export var force : float = 0.75

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key_event = event as InputEventKey
		if key_event.keycode == KEY_KP_1:
			spawn_tween(Vector3(-force, 0, force))
		elif key_event.keycode == KEY_KP_2:
			spawn_tween(Vector3(0, 0, force))
		elif key_event.keycode == KEY_KP_3:
			spawn_tween(Vector3(force, 0, force))
		elif key_event.keycode == KEY_KP_6:
			spawn_tween(Vector3(force, 0, 0))
		elif key_event.keycode == KEY_KP_9:
			spawn_tween(Vector3(force, 0, -force))
		elif key_event.keycode == KEY_KP_8:
			spawn_tween(Vector3(0, 0, -force))
		elif key_event.keycode == KEY_KP_7:
			spawn_tween(Vector3(-force, 0, -force))
		elif key_event.keycode == KEY_KP_4:
			spawn_tween(Vector3(-force, 0, 0))

func spawn_tween(force_in : Vector3) -> void:
		robot_2.apply_force(force_in)
