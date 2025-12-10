@tool
class_name CameraController extends Node3D

var left = false
var right = false
var up = false
var down = false
var zoom_in = false
var zoom_out = false

@export var cur_size : float
@export var move_speed : float = 20.
@export var enabled : bool = true
@export var camera : CameraSizer = null

func move_cam(delta_pos : Vector3) -> void:
	var trans = Transform3D().rotated(Vector3(0,1,0), deg_to_rad(45))
	position += delta_pos * trans

func _process(delta):
	if not enabled:
		return
	var dir = Vector3.ZERO
	if left:
		dir.x = -1
	if right:
		dir.x = +1
	if up:
		dir.z = -2
	if down:
		dir.z = +2
	if zoom_in:
		cur_size -= 1
	if zoom_out:
		cur_size += 1
	dir *= move_speed * delta
	move_cam(dir)

	cur_size = clamp(cur_size, 5, 75)
	if camera:
		camera.size = cur_size

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_Q:
			left = event.pressed
		if event.keycode == KEY_D:
			right = event.pressed
		if event.keycode == KEY_Z:
			up = event.pressed
		if event.keycode == KEY_S:
			down = event.pressed
		if event.keycode == KEY_R:
			zoom_in = event.pressed
		if event.keycode == KEY_F:
			zoom_out = event.pressed
