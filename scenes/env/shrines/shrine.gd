class_name Shrine extends Node3D

@export var activated: bool = false
@export var activator: Node3D = null
@export var activation_range: float = 3.0

func activate():
	pass

func _physics_process(_delta: float) -> void:
	if activator and not activated:
		var dist = global_position.distance_to(activator.global_position)
		if dist < activation_range:
			activated = true
			activate()
			queue_free()
