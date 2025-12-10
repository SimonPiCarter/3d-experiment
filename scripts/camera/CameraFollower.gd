@tool
class_name CameraFollower extends Camera3D

@export var ref_camera : Camera3D = null

func _process(_delta):
	if ref_camera:
		global_position = ref_camera.global_position
		rotation = ref_camera.rotation
		size = ref_camera.size
		projection = ref_camera.projection
		fov = ref_camera.fov
		near = ref_camera.near
		far = ref_camera.far
