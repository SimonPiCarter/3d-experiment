@tool
class_name CameraSizer extends Camera3D

func get_up() -> Vector3:
	return transform * Vector3.UP - position

func get_left() -> Vector3:
	return transform * Vector3.LEFT - position

func get_forward() -> Vector3:
	return transform * Vector3.FORWARD - position

func _process(_delta: float) -> void:
	far = max(50, 4*size)
	position = transform.basis * Vector3(0,0,1) * size
