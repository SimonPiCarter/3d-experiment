class_name WorldInput extends Control

@export var camera_controller : CameraController = null
@export var ref_camera : CameraSizer = null
@export var pick_texture : Texture2D = null
@export var debug : Node3D = null
@export var ent_moving : Array[Node3D] = []
@export var targets : Node3D = null
@export var box : BoxMouse = null

var middle_btn_pressed : bool = false

func calculate_floor_click(event: InputEvent) -> Vector3:
	var rational_pos = Vector2(
		event.position.x / get_viewport_rect().size.x - 0.5,
		event.position.y / get_viewport_rect().size.y - 0.5
	)
	var size_ratio = get_viewport_rect().size.x / get_viewport_rect().size.y
	var world_pos = ref_camera.global_position \
		- rational_pos.x * ref_camera.get_left() * ref_camera.size * size_ratio \
		- rational_pos.y * ref_camera.get_up() * ref_camera.size

	var forward = ref_camera.get_forward()
	var floor_y = -0.15
	var t = (floor_y - world_pos.y) / forward.y
	return world_pos + forward * t

var boxing = false
var start_box : Vector2

func _input(event: InputEvent) -> void:
	if not ref_camera:
		return
	if event is InputEventMouseMotion:
		if boxing and box:
			box.update(start_box, event.position)
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			boxing = true
			start_box = event.position
			if box:
				box.update(start_box, start_box)
				box.show()
	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var floor_clic = calculate_floor_click(event)
			if debug:
				debug.global_position = floor_clic + Vector3(0,0.1,0)
			for ent in ent_moving:
				ent.set_target_position(floor_clic)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if boxing:
				boxing = false
				if box:
					box.hide()
			if pick_texture:
				if box:
					ent_moving = []
					var selected = Picker.get_nodes_from_texture(pick_texture, box.get_rect())
					for e in selected:
						if e is QuadEntityTargetMove or e is VatMeshInstanceTargetMove:
							ent_moving.append(e)
				else:
					var picked = Picker.get_node_from_texture(pick_texture, int(event.position.x), int(event.position.y))
					if picked:
						ent_moving = [picked]
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			if targets:
				var floor_click = calculate_floor_click(event)
				var new_explo = preload("res://scenes/VFX/Explosion/explo_sphere_dust.tscn").instantiate()
				targets.get_parent().add_child(new_explo)
				new_explo.global_position = floor_click
				for child in targets.get_children():
					if not child.dead:
						var dist = (child.global_position - floor_click).length()
						if dist < 4.:
							child.health.damage(5)
	#
	#if event is InputEventKey and event.is_pressed():
	#	if event.keycode == KEY_S and ent_moving:
	#		ent_moving.stop_movement()

	if event is InputEventMouseButton:
		var m_event = event as InputEventMouseButton
		if m_event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			camera_controller.cur_size += 2
		if m_event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			camera_controller.cur_size -= 2
		if m_event.button_index == MOUSE_BUTTON_MIDDLE:
			middle_btn_pressed = event.is_pressed()

	if event is InputEventMouseMotion:
		var m_event = event as InputEventMouseMotion
		if middle_btn_pressed:
			camera_controller.move_cam(Vector3(-m_event.relative.x, 0, -m_event.relative.y) * 0.1)
