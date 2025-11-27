@tool
class_name CircleContainer extends Control

@export var radius_first : float = 100.
@export var radius_delta : float = 100.
@export var min_distance : float = 100.
@export var angle_min : float = -45. 
@export var angle_max : float = 45. 

@export var dirty = false
@onready var elements : Array[Control] = []

@onready var circles: Control = $Circles
var spin_angle = 0.

func _ready():
	refresh_elements()
	refresh_position()

func refresh_elements() -> void:
	elements.clear()
	for child in get_children():
		if child is Control and child != circles:
			elements.append(child)
	

func refresh_position() -> void:
	var current_radius = radius_first
	var distance = current_radius * 2*PI / deg_to_rad(angle_max-angle_min)
	var n = floor(distance/min_distance)
	var idx = 0

	for elt in elements:
		if idx > n:
			current_radius = current_radius+radius_delta
			distance = current_radius * 2*PI / deg_to_rad(angle_max-angle_min)
			n = floor(distance/min_distance)
			idx = 0
		
		elt.set_anchors_preset(Control.PRESET_CENTER)
		var cur_angle = deg_to_rad(angle_min + idx * (angle_max-angle_min)/n + spin_angle)
		elt.position = size/2 + current_radius*Vector2(cos(cur_angle), sin(cur_angle)) - elt.size / 2.
		idx += 1

func spin() -> void:
	spin_angle = 0.
	var t = get_tree().create_tween()
	t.tween_property(self, "spin_angle", 10., 0.5).set_trans(Tween.TRANS_CUBIC)

func _process(delta: float) -> void:
	if dirty:
		refresh_elements()
		dirty = false
	refresh_position()
