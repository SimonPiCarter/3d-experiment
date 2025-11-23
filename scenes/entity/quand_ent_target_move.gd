class_name QuadEntityTargetMove extends QuadEntity

var target_position: Vector3 = Vector3.ZERO

func set_target_position(new_target: Vector3) -> void:
	target_position = new_target

func _ready():
	super._ready()
	stop_movement()

func stop_movement() -> void:
	target_position = global_position

func _physics_process(delta: float) -> void:
	var direction = target_position - global_position
	direction.y = 0
	if direction.length() < 0.1:
		direction = Vector3.ZERO
	_handle_movement(direction.normalized(), delta)
