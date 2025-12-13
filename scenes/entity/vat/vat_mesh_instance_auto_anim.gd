@tool
class_name VatMeshInstanceAutoAnim extends VatMeshInstance

@export var walking_anim : int = 0
@export var idle_anim : int = 0
@export var move_speed : float = 3.
@export var turn_speed : float = 1.*PI

var cur_delta: float = 1.

func _ready() -> void:
	super._ready()

func set_anim(new_animation : int) -> void:
	if animation == new_animation:
		return
	animation = new_animation

func _handle_movement(direction: Vector3, delta):
	cur_delta = delta
	var length_dir = direction.length()
	var norm_dir = direction / length_dir if length_dir > 0.0001 else Vector3.ZERO
	_real_handle_movement(norm_dir * move_speed * delta)

func _real_handle_movement(speed: Vector3):
	var forward = transform * Vector3.FORWARD - position
	position += speed

	if speed.length() <= 0.0001:
		set_anim(idle_anim)
		return
	set_anim(walking_anim)

	var delta_angle = speed.signed_angle_to(forward, Vector3.UP)
	if abs(delta_angle) > 0.01:
		var max_angle = turn_speed * cur_delta
		rotate_object_local(Vector3.UP, -clamp(delta_angle, -max_angle, max_angle))
