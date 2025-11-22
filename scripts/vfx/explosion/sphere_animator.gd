class_name SphereAnimator extends Node3D

@export_range(0.,1.) var threshold_start = 0.
@export_range(0.,1.) var threshold_end = 1.
@export var lowering_start : float = 1.
@export var lowering_time : float = 1.
@export_range(0.,1.) var threshold_vanishing_start = 0.
@export_range(0.,1.) var threshold_vanishing_end = 1.
@export var vanishing_start : float = 1.
@export var vanishing_time : float = 1.
@export var loop : bool = true
@export var loop_wait_time : float = 1.
@export var sphere : SphereVFX = null
@export var rotation_speed : float = 0.

@export var running = false
var elapsed = -1.

func _process(delta):
	if not running:
		return
	if not sphere:
		return
	sphere.rotate_y(rotation_speed*delta)
	var time = max(lowering_start +lowering_time, vanishing_start + vanishing_time)
	if elapsed <= 0 or (elapsed >= loop_wait_time and loop):
		sphere.threshold = threshold_start
		sphere.threshold_alpha = threshold_vanishing_start
		if lowering_time >= 0:
			var t = get_tree().create_tween()
			t.tween_interval(lowering_start)
			t.tween_property(sphere, "threshold", threshold_end, lowering_time)
		if vanishing_time >= 0:
			var t = get_tree().create_tween()
			t.tween_interval(vanishing_start)
			t.tween_property(sphere, "threshold_alpha", threshold_vanishing_end, vanishing_time)
		elapsed = 0.
	elapsed += delta
