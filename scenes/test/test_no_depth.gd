extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D3
@onready var mesh_instance_3d_2: MeshInstance3D = $MeshInstance3D4
@onready var mesh_instance_3d_3: MeshInstance3D = $MeshInstance3D5

func create_scale_tween(object) -> void:
		var t = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		t.tween_property(object, "scale", Vector3.ONE, 0.2)
		t.tween_property(object, "scale", Vector3.ZERO, 0.2)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		create_scale_tween(mesh_instance_3d)
		create_scale_tween(mesh_instance_3d_2)
		create_scale_tween(mesh_instance_3d_3)
 
