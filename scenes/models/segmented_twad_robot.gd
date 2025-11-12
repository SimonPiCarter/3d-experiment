extends TwoSegmentObject
@export var speed : float = 5.

var direction : Array[bool] = [false,false,false,false]

func _process(delta):
	if direction[0]:
		self.segments[0].anchor_1.position.x -= speed*delta
	if direction[1]:
		self.segments[0].anchor_1.position.x += speed*delta
	if direction[2]:
		self.segments[0].anchor_1.position.z -= speed*delta
	if direction[3]:
		self.segments[0].anchor_1.position.z += speed*delta
	super._process(delta)


func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_LEFT:
			direction[0] = event.is_pressed()
		if event.keycode == KEY_RIGHT:
			direction[1] = event.is_pressed()
		if event.keycode == KEY_UP:
			direction[2] = event.is_pressed()
		if event.keycode == KEY_DOWN:
			direction[3] = event.is_pressed()
