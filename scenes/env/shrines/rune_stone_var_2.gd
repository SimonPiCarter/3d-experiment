extends Node3D

@export var speed_rot = PI/4.
@export var speed_osc = PI/2.
@export var ampl_osc = 0.25
@export var delta_osc = 0.25
@export var ray : float = 1.

@onready var circle_arranger_1: CircleArranger = $StoneCircle/CircleArranger
@onready var circle_arranger_2: CircleArranger = $StoneCircle/CircleArranger2
@onready var circle_arranger_3: CircleArranger = $StoneCircle/CircleArranger3
@onready var circles = [
	$StoneCircle/CircleArranger,
	$StoneCircle/CircleArranger2,
	$StoneCircle/CircleArranger3
]

class Cube:
	var node : Node3D
	var idx : int
	var init_y : float

var cubes : Array[Cube] = []

func _ready() -> void:
	var idx = 0
	for circle in circles:
		for child in circle.get_children():
			var cube = Cube.new()
			cube.node = child
			cube.idx = idx
			cube.init_y = child.position.y
			cubes.append(cube)
			idx += 1

var elapsed_osc = 0.
func _process(delta: float) -> void:
	circle_arranger_1.ray = ray * 1.0
	circle_arranger_1.update()
	circle_arranger_1.rotation.y += delta * speed_rot * 0.9
	circle_arranger_2.ray = ray * 1.25
	circle_arranger_2.update()
	circle_arranger_2.rotation.y += delta * speed_rot * 1.0
	circle_arranger_3.ray = ray * 1.5
	circle_arranger_3.update()
	circle_arranger_3.rotation.y += delta * speed_rot * 1.1
	elapsed_osc += delta * speed_osc
	for cube in cubes:
		cube.node.position.y = cube.init_y + ampl_osc * cos(delta_osc * cube.idx + elapsed_osc)
