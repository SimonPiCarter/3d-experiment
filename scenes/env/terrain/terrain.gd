@tool
extends Node3D

const ELEMENT = preload("uid://dga3q1vfy3ub1")

@export var x : int = 10
@export var y : int = 10
@export var init : bool = false
var old_init : bool = true

func _ready() -> void:
	set_up()

func set_up() -> void:
	for child in get_children():
		child.queue_free()

	for i in x:
		for j in y:
			var mesh = MeshInstance3D.new()
			mesh.mesh = ELEMENT
			mesh.position = Vector3(i*1.05,-5,j*1.05)
			add_child(mesh)

func _process(_delta: float) -> void:
	if old_init != init:
		old_init = init
		set_up()
