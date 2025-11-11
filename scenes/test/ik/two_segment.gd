extends Node3D
@onready var two_segment_object = $TwoSegmentObject
@export var speed : float = 5.

var direction : Array[bool] = [false,false,false,false]

func _process(delta):
	if direction[0]:
		two_segment_object.segments[0].anchor_1.position.x -= speed*delta
	if direction[1]:
		two_segment_object.segments[0].anchor_1.position.x += speed*delta
	if direction[2]:
		two_segment_object.segments[0].anchor_1.position.z -= speed*delta
	if direction[3]:
		two_segment_object.segments[0].anchor_1.position.z += speed*delta

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_Q:
			direction[0] = event.is_pressed()
		if event.keycode == KEY_D:
			direction[1] = event.is_pressed()
		if event.keycode == KEY_Z:
			direction[2] = event.is_pressed()
		if event.keycode == KEY_S:
			direction[3] = event.is_pressed()
