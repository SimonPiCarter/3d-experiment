class_name Spawner extends Node3D

@export var spawn_center : Node3D
@export var destination : Node3D
@export var spawned_object : PackedScene
@export var spawn_rate : float = 2.
@export var spawn_range : float = 10.
@export var y_pos = 0.
@export var spawn_scale = 1.

var elapsed = 0.

func _process(delta) -> void:
	if not spawn_center or not destination:
		return
	elapsed += delta
	while elapsed >= spawn_rate:
		elapsed -= spawn_rate
		var small_bot = spawned_object.instantiate()
		small_bot.scale = Vector3.ONE * spawn_scale
		small_bot.position = spawn_center.position + Vector3(
			randf_range(-spawn_range,spawn_range), 
			0., 
			randf_range(-spawn_range,spawn_range)
		)
		small_bot.position.y = y_pos
		destination.add_child(small_bot)
