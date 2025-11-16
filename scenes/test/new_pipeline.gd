extends Node3D

@onready var basic_round_projectile_explo = $MainViewport/SubViewport/Projectiles/BasicRoundProjectileExplo
@onready var basic_round_projectile = $MainViewport/SubViewport/Projectiles/BasicRoundProjectile
@onready var targets = $MainViewport/SubViewport/Targets
@onready var simple_robot = $MainViewport/SubViewport/SimpleRobot

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_A:
		var robot = simple_robot.get_node("SimpleRobot") as SimpleRobot
		basic_round_projectile.start_pos = robot.get_source()
		var target = find_target()
		if target:
			basic_round_projectile.end_pos = target.global_position
			basic_round_projectile.effect = func(): impact(target)
			basic_round_projectile.start()

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_E:
		var robot = simple_robot.get_node("SimpleRobot") as SimpleRobot
		basic_round_projectile_explo.start_pos = robot.get_source()
		var target = find_target()
		if target:
			basic_round_projectile_explo.end_pos = target.global_position
			basic_round_projectile_explo.effect = func(): impact(target)
			basic_round_projectile_explo.start()

func impact(target):
	if not target.dead:
		target.health.damage(1.)

func find_target() -> Robot3:
	var min_dist = -1.
	var best = null
	for child in targets.get_children():
		if not child.dead:
			var dist = (child.global_position - simple_robot.global_position).length()
			if dist < min_dist or min_dist < 0.:
				best = child
				min_dist = dist
	return best
