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

func _ready() -> void:
	ref_pos = position

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
			dir.z = -2
		if down:
			dir.z = +2
		if zoom_in:
			zoom = -1
		if zoom_out:
			zoom = +1
		dir *= move_speed * delta
		var trans = Transform3D().rotated(Vector3(0,1,0), deg_to_rad(45))
		cur_move += dir * trans
		position = ref_pos + cur_move

		size = clamp(size+zoom, 5, 75)
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
