extends Control
@onready var circle_container: CircleContainer = $CircleContainer

@onready var reserve: Control = $Reserve/ButtonRound
var is_spinning = false
var is_going_down = false

func spin(is_down : bool) -> void:
	if is_spinning:
		return
	is_spinning = true
	is_going_down = is_down
	var angle = (circle_container.angle_max - circle_container.angle_min) / (circle_container.elements.size()-1)
	if not is_down:
		angle = -angle
	circle_container.spin_angle = 0.
	var elt = circle_container.elements.back() if is_down else circle_container.elements.front()
	elt.modulate = Color(1,1,1,1)
	reserve.modulate = Color(1,1,1,0)
	reserve.visible = true
	var time = 0.1
	var t = get_tree().create_tween()
	t.tween_property(circle_container, "spin_angle", angle, time).set_trans(Tween.TRANS_CUBIC)
	t.parallel().tween_property(elt, "modulate", Color(1,1,1,0), time).set_trans(Tween.TRANS_CUBIC)
	t.parallel().tween_property(reserve, "modulate", Color(1,1,1,1), time).set_trans(Tween.TRANS_CUBIC)
	t.tween_callback(circle_elt)

func _process(_delta) -> void:
	var cur_angle = deg_to_rad(circle_container.angle_min - (circle_container.angle_max-circle_container.angle_min)/(circle_container.elements.size()-1) + circle_container.spin_angle)
	if not is_going_down:
		cur_angle = deg_to_rad(circle_container.angle_max + (circle_container.angle_max-circle_container.angle_min)/(circle_container.elements.size()-1) + circle_container.spin_angle)
	reserve.position = circle_container.size/2 + circle_container.radius_first*Vector2(cos(cur_angle), sin(cur_angle)) - reserve.size / 2.

func circle_elt():
	var backup = circle_container.elements.back()
	if not is_going_down:
		backup = circle_container.elements.front()
	backup.visible = false
	circle_container.elements.erase(backup)
	if is_going_down:
		circle_container.elements.insert(0, reserve)
	else:
		circle_container.elements.append(reserve)
	reserve = backup
	circle_container.spin_angle = 0.
	is_spinning = false
