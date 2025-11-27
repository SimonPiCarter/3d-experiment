class_name FreeRoamingCamera3D extends Camera3D


var left = false
var right = false
var up = false
var down = false
var zoom_in = false
var zoom_out = false
const MOUSE_SENSITIVITY := 0.002

@export var move_speed : float = 20.
@export var rotation_speed : float = 1.
@export var ref_camera : Camera3D = null

func get_up() -> Vector3:
	return transform * Vector3.UP - position

func get_left() -> Vector3:
	return transform * Vector3.LEFT - position

func get_forward() -> Vector3:
	return transform * Vector3.FORWARD - position

func sync():
	if ref_camera:
		position = ref_camera.position
		rotation = ref_camera.rotation
		size = ref_camera.size

func _process(delta):
	if ref_camera:
		sync()
	else:
		var zoom = 0
		var dir = Vector3.ZERO
		if left:
			dir.x = -1
		if right:
			dir.x = +1
		if up:
			dir.y = +1
		if down:
			dir.y = -1
		if zoom_in:
			zoom = -1
		if zoom_out:
			zoom = +1

		translate(dir * move_speed * delta)
		size = clamp(size+zoom, 5, 50)

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
