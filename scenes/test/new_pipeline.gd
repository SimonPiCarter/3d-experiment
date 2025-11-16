extends Node3D

@onready var basic_round_projectile_explo = $MainViewport/SubViewport/Projectiles/BasicRoundProjectileExplo
@onready var basic_round_projectile = $MainViewport/SubViewport/Projectiles/BasicRoundProjectile
@onready var targets = $MainViewport/SubViewport/Targets
@onready var healer_bot: QuadEntity = $MainViewport/SubViewport/HealerBot

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_A:
		var robot = healer_bot.get_node("robot2") as Robot2
		basic_round_projectile.start_pos = robot.get_source()
		var target = find_target()
		if target:
			basic_round_projectile.end_pos = target.global_position
			basic_round_projectile.effect = func(): impact(target)
			basic_round_projectile.start()
			robot.power()

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_E:
		var robot = healer_bot.get_node("robot2") as Robot2
		basic_round_projectile_explo.start_pos = robot.get_source()
		var target = find_target()
		if target:
			basic_round_projectile_explo.end_pos = target.global_position
			basic_round_projectile_explo.effect = func(): impact(target)
			basic_round_projectile_explo.start()
			robot.attack()

func impact(target):
	if not target.dead:
		target.health.damage(1.)

func find_target() -> Robot3:
	var min_dist = -1.
	var best = null
	for child in targets.get_children():
		if not child.dead:
			var dist = (child.global_position - healer_bot.global_position).length()
			if dist < min_dist or min_dist < 0.:
				best = child
				min_dist = dist
	return best
