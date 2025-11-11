class_name TwoSegmentObject extends Node3D

@export var segments : Array[AnchorDynamic]= []

func _process(delta):
	var last_segment = null
	for segment in segments:
		if last_segment:
			segment.anchor_1.global_position = last_segment.anchor_2.global_position
		segment.update()
		last_segment = segment
