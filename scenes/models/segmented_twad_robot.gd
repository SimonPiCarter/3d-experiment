extends TwoSegmentObject

@export var move_speed : float = 5.
@export var turn_speed : float = 3.

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _handle_movement(delta):
	var dir = Input.get_axis('ui_down', 'ui_up')
	self.segments[0].anchor_1.translate(Vector3(0, 0, dir) * move_speed * delta)
	self.segments[0].anchor_1.translate(Vector3(0, 0, dir) * move_speed * delta)

	var a_dir = Input.get_axis('ui_right', 'ui_left')
	self.segments[0].anchor_1.rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)
