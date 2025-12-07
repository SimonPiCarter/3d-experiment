extends Node3D

@export var room_ray : float = 5.0
@export var nb_objects : int = 100
@export var diff_time : float = 5.0
@onready var multi_mesh: MultiMeshInstance3D = $MultiMeshInstance3D
@onready var sphere_vfx: SphereVFX = $SphereVFX

var offsets : Array[float] = []

func _ready() -> void:
	run()

func run() -> void:
	var multi_mesh_data : MultiMesh = multi_mesh.multimesh
	multi_mesh_data.instance_count = nb_objects
	offsets.clear()
	for i in range(nb_objects):
		var angle = i * TAU / nb_objects
		var x = room_ray * cos(angle)
		var z = room_ray * sin(angle)
		offsets.append(randf_range(-2, 2))
		multi_mesh_data.set_instance_transform(i, Transform3D(Basis(), Vector3(x, -22. + offsets[i], z)))
	sphere_vfx.scale = Vector3.ONE * 2. * room_ray - Vector3.ONE * 5.

func despawn():
	is_running = true
	is_spawning = false
	elapsed_time = -1.0
	sphere_vfx.threshold_alpha = 1.
	var t = get_tree().create_tween()
	t.tween_property(sphere_vfx, "threshold_alpha", 0., 3.)

func spawn():
	is_running = true
	is_spawning = true
	elapsed_time = 0.0
	sphere_vfx.threshold_alpha = 0.
	var t = get_tree().create_tween()
	t.tween_property(sphere_vfx, "threshold_alpha", 1., 3.)

var elapsed_time : float = 0.0
var is_spawning = true
var is_running = false

func _process(delta: float) -> void:
	if not is_running:
		return
	elapsed_time += delta
	var multi_mesh_data : MultiMesh = multi_mesh.multimesh
	for i in range(nb_objects):
		var delay = float(i) / float(nb_objects) * diff_time
		var time = elapsed_time - delay
		var trans : Transform3D = multi_mesh_data.get_instance_transform(i)
		trans.origin.y = lerp(trans.origin.y, offsets[i]- (22 if not is_spawning else 0), clamp(time, 0, 1))
		multi_mesh_data.set_instance_transform(i, trans)
