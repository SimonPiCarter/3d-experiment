extends Control
@onready var socle: Node3D = $MainViewport/SubViewport/socle

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			socle.rotate_y(0.1)
		if mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP:
			socle.rotate_y(-0.1)

func _process(delta) -> void:
	socle.rotate_y(-0.1*delta)
