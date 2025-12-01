extends Node3D

@export var cycle = 4.
@export var factor = 1.
@export var amplitude = 2.
@export var nodes : Array[Node3D] = []
@export var oscillation_speed = 1.
@export var amplitude_curve : Curve
@export var delay_curve : Curve
@export var distance = 1.5

var cur_angle = 0.

func _ready() -> void:
	return
	for i in nodes.size():
		nodes[i].position = Vector3(0,0,distance*i)

func _process(delta: float) -> void:
	if nodes.size() == 0:
		return
	cur_angle += oscillation_speed*delta
	var last_ampl = 0
	var last_delay = 0
	for i in nodes.size():
		var index = float(i)/nodes.size()
		var ampl = amplitude_curve.sample(index)
		var delay = delay_curve.sample(index)
		nodes[i].position.y = cos(cur_angle+delay) * ampl * amplitude
		if i > 0:
			nodes[i].look_at(nodes[i-1].position + position)
		last_ampl = ampl
		last_delay = delay
