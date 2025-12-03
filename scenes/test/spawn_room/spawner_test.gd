extends Node3D

@export var spacing = 2.
@export var sizing = 75
@export var model : MeshInstance3D = null

func _ready():
	ring_populate()
	run()
	
func ring_populate() -> void:
	for i in 4.*sizing:
		var new_model = model.duplicate()
		new_model.visible = true
		var angle = float(i) / sizing * 0.5 * PI
		new_model.position = Vector3(cos(angle) * sizing + randf_range(0.,0.2), 0., sin(angle) * sizing + randf_range(-0.5,0.5))
		add_child(new_model)

func populate() -> void:
	for i in sizing:
		var new_model = model.duplicate()
		new_model.visible = true
		new_model.position = Vector3(i*spacing + randf_range(0.,0.2), 0., randf_range(-0.5,0.5))
		add_child(new_model)
	for i in sizing:
		var new_model = model.duplicate()
		new_model.visible = true
		new_model.position = Vector3(sizing*spacing + randf_range(-0.5,0.5), 0., i*spacing + randf_range(0.,0.2))
		add_child(new_model)
	for i in sizing:
		var new_model = model.duplicate()
		new_model.visible = true
		new_model.position = Vector3(sizing*spacing - i*spacing + randf_range(0.,0.2), 0., sizing*spacing + randf_range(-0.5,0.5))
		add_child(new_model)
	for i in sizing:
		var new_model = model.duplicate()
		new_model.visible = true
		new_model.position = Vector3(randf_range(-0.5,0.5), 0., sizing*spacing - i*spacing + randf_range(0.,0.2))
		add_child(new_model)


func run() -> void:
	var i = 0
	for child in get_children():
		var t = get_tree().create_tween()
		child.position.y = -22
		var old_pos = child.position
		old_pos.y = 8
		t.tween_interval(i/float(get_child_count()))
		t.tween_property(child, "position", old_pos + Vector3(0,-4+randf_range(-6, 6),0), 0.8+randf_range(-0.2,0.4)).set_trans(Tween.TRANS_SPRING)
		i += 1
	var t = get_tree().create_tween()
	t.tween_interval(2.)
	var sphere = $"../SphereVFX"
	sphere.threshold_alpha = 0.
	t.tween_property(sphere, "threshold_alpha", 1., 5.)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_P:
		run()
