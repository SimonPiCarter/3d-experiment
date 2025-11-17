class_name BasicRoundProjectile extends Node3D

@export var start_pos : Vector3 = Vector3.ZERO
@export var target : Node3D = null
@export var speed : float = 10.
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@export var explosion : BaseExplosion = null

var effect : Callable = no_effect

var done = true

func no_effect():
	pass

func _ready():
	mesh_instance_3d.scale = Vector3.ZERO
	if explosion:
		explosion.setup()
		explosion.explosion_finished.connect(_on_explosion_finished)

func _on_explosion_finished() -> void:
	queue_free()

var start_tween : Tween = null
func start() -> void:
	if !done:
		return
	done = false
	position = start_pos
	start_tween = get_tree().create_tween()
	start_tween.tween_property(mesh_instance_3d, "scale", Vector3.ONE, 0.1)

func _process(delta):
	if done:
		return
	var diff = target.global_position - global_position
	var length = diff.length()
	if length < speed * delta:
		done = true
		global_position = target.global_position
		effect.call()
		start_tween.kill()
		var t = get_tree().create_tween()
		t.tween_property(mesh_instance_3d, "scale", Vector3.ZERO, 0.01)
		if explosion:
			explosion.fire(0.)
	else:
		global_position += diff / length * speed * delta
