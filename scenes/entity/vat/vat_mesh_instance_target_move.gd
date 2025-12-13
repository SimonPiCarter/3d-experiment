@tool
class_name VatMeshInstanceTargetMove extends VatMeshInstanceAutoAnim

@export var target_position: Vector3 = Vector3.ZERO
@export var enabled : bool = false

func set_target_position(new_target: Vector3) -> void:
	target_position = new_target
	target_position.y = global_position.y

func _ready():
	stop_movement()
	enabled = true
	super._ready()

func stop_movement() -> void:
	target_position = global_position

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	var direction = target_position - global_position
	if direction.length() < 0.1:
		direction = Vector3.ZERO
	else:
		direction = direction.normalized()
	_handle_movement(direction, delta)
