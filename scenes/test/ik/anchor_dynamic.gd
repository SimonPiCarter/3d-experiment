class_name AnchorDynamic extends Node3D

@export var anchor_1 : Node3D = null
@export var anchor_2 : Node3D = null
@export var body : Node3D = null
@export var min_distance : float = 0.9
@export var max_distance : float = 1.0

func update():
	if not anchor_1 or not anchor_2:
		return
	var diff = anchor_1.position - anchor_2.position
	var sqdiff = diff.x*diff.x+diff.y*diff.y+diff.z*diff.z
	if sqdiff > max_distance*max_distance:
		anchor_2.position = anchor_1.position - diff.normalized()*max_distance
	elif sqdiff < min_distance*min_distance:
		anchor_2.position = anchor_1.position - diff.normalized()*min_distance
	if body and anchor_2.global_position != anchor_1.global_position:
		body.look_at_from_position((anchor_2.global_position+anchor_1.global_position)/2., anchor_1.global_position)
