@tool
extends Node3D

@onready var cube1 = $MeshInstance3D
@onready var cube2 = $MeshInstance3D2
@onready var cube3 = $MeshInstance3D3

func _process(delta):
	cube1.rotate_x(deg_to_rad(90.*delta))
	cube2.rotate_y(deg_to_rad(90.*delta))
	cube3.rotate_z(deg_to_rad(90.*delta))
