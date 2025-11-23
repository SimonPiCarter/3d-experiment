extends Control

@export var ref_camera : FreeRoamingCamera3D = null
@export var pick_texture : Texture2D = null
@export var debug : Node3D = null
@export var ent_moving : Array[QuadEntityTargetMove] = []

func _input(event: InputEvent) -> void:
	if not ref_camera:
		return
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var rational_pos = Vector2(event.position.x/get_viewport_rect().size.x - 0.5,
				event.position.y/get_viewport_rect().size.y - 0.5)
			var size_ratio = get_viewport_rect().size.x / get_viewport_rect().size.y
			var world_pos = ref_camera.global_position\
				- rational_pos.x * ref_camera.get_left() * ref_camera.size * size_ratio\
				- rational_pos.y * ref_camera.get_up() * ref_camera.size

			var forward = ref_camera.get_forward()
			var floor_y = -0.15
			var t = (floor_y - world_pos.y) / forward.y
			var floor_clic = world_pos + forward*t
			if debug:
				debug.global_position = floor_clic + Vector3(0,0.1,0)
			for ent in ent_moving:
				ent.set_target_position(floor_clic)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if pick_texture:
				var picked = Picker.get_node_from_texture(pick_texture, int(event.position.x), int(event.position.y))
				print(picked)
				if picked:
					ent_moving = [picked]

	#
	#if event is InputEventKey and event.is_pressed():
	#	if event.keycode == KEY_S and ent_moving:
	#		ent_moving.stop_movement()
