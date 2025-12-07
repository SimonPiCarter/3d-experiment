extends Node3D

@export var speed_rot = PI/4.
@export var speed_osc = PI/2.
@export var ampl_osc = 0.5

var ref_y = 0.

@onready var rune_mesh_1: MeshInstance3D = $RunStone

func _ready():
	ref_y = rune_mesh_1.position.y

var elapsed = 0.
func _process(delta: float) -> void:
	elapsed += delta
	rune_mesh_1.rotation.y += delta*speed_rot
	rune_mesh_1.position.y = ref_y + ampl_osc * cos(speed_osc*elapsed)
