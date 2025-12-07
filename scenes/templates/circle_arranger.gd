@tool
class_name CircleArranger extends Node3D

@export var ray : float = 20.
@export var rotate : bool = false

func _ready():
	update()

func _validate_property(property: Dictionary): # update the config warnings
	if property.name == "ray":
		update()

func update():
	if get_child_count() == 0:
		return
	var angle = TAU / get_child_count()
	for i in get_child_count():
		var child = get_child(i)
		child.position = Vector3(ray*cos(i*angle), child.position.y, ray*sin(i*angle))
		if rotate:
			child.rotation.y = -i*angle
