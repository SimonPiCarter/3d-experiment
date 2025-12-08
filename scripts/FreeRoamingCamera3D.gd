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
@export var enabled : bool = true

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
		projection = ref_camera.projection
		fov = ref_camera.fov
		near = ref_camera.near
		far = ref_camera.far

var ref_pos : Vector3
var cur_move : Vector3
var cur_size : float

func _ready() -> void:
	ref_pos = position
	cur_size = size

func move_cam(delta_pos : Vector3) -> void:
	var trans = Transform3D().rotated(Vector3(0,1,0), deg_to_rad(45))
	cur_move += delta_pos * trans

func _process(delta):
	if ref_camera:
		sync()
	else:
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
		position = ref_pos + cur_move

		cur_size = clamp(cur_size, 5, 75)
		size = cur_size
		far = max(50, 4*size)
		var move = transform.basis * Vector3(0,0,1) * size
		position += move

func _input(event):
	if not enabled:
		return
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
