extends Timer

@export var spawner : Spawner = null

func _ready() -> void:
	timeout.connect(buff_spawner)

func buff_spawner():
	if spawner:
		spawner.spawn_rate = clamp(spawner.spawn_rate-1., 0.1, 1000000000)
