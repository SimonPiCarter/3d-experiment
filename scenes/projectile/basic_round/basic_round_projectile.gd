extends Node3D

@export var start_pos : Vector3 = Vector3.ZERO
@export var end_pos : Vector3 = Vector3.ZERO
@export var speed : float = 10.
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var done = true
func start() -> void:
	if !done:
		return
	done = false
	position = start_pos
	$Explosions.rotate_y(randf_range(0.,2.*PI))
	var t = get_tree().create_tween()
	var time = (end_pos - position).length()/speed
	t.tween_property(mesh_instance_3d, "scale", Vector3.ONE, 0.1)
	t.tween_property(self, "position", end_pos, time)
	t.tween_property(mesh_instance_3d, "scale", Vector3.ZERO, 0.01)
	t.tween_property(self, "done", true, 0.)
	for children in $Explosions.get_children():
		var tw = get_tree().create_tween()
		tw.tween_property(children, "scale", Vector3.ONE, 0.1).set_delay(time+0.1)
		tw.tween_property(children, "scale", Vector3.ZERO, 0.1).set_delay(0.1)
