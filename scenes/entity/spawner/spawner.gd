class_name Spawner extends Node3D

@export var spawn_center : Node3D
@export var destination : Node3D
@export var spawned_object : PackedScene
@export var spawn_rate : float = 2.
@export var spawn_range : float = 10.
@export var y_pos = 0.
@export var spawn_scale = 1.
@export var target : Node3D

var elapsed = 0.

func _process(delta) -> void:
	if not spawn_center or not destination:
		return
	elapsed += delta
	while elapsed >= spawn_rate:
		elapsed -= spawn_rate
		var spawned = spawned_object.instantiate()
		if target:
			if spawned is Robot3:
				spawned.target = target
			elif spawned is Shrine:
				spawned.buff = target
				spawned.activator = target
		spawned.scale = Vector3.ONE * spawn_scale
		spawned.position = spawn_center.position + Vector3(
			randf_range(-spawn_range,spawn_range), 
			0., 
			randf_range(-spawn_range,spawn_range)
		)
		spawned.position.y = y_pos
		destination.add_child(spawned)
