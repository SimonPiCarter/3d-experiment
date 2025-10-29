class_name Laser extends MeshInstance3D

@export var beam : Node3D
@export var boom : Node3D

func _ready() -> void:
	beam.hide()
	beam.scale = Vector3(1.,0,0)
	boom.hide()
	boom.scale = Vector3.ZERO

func fire() -> void:
	beam.scale = Vector3(1.,0,0)
	beam.show()
	var t = get_tree().create_tween()
	t.tween_property(beam, "scale", Vector3.ONE, 0.075)
	t.tween_property(beam, "scale", Vector3(1.,0,0), 0.075)
	t.tween_callback(func(): beam.hide())

	boom.scale = Vector3.ONE
	t = get_tree().create_tween()
	t.tween_interval(0.075)
	t.tween_callback(func(): boom.show())
	t.tween_interval(0.025)
	t.tween_callback(func(): boom.hide())

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_A and event.is_pressed():
		fire()
