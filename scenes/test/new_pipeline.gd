extends Node3D

@onready var targets = $MainViewport/SubViewport/Targets
@onready var healer_bot: QuadEntity = $MainViewport/SubViewport/HealerBot

func _ready() -> void:
	var id = Picker.get_next_id()
	Picker.register_new_pickable(id, healer_bot)
	id = Picker.get_next_id()
	Picker.register_new_pickable(id, $MainViewport/SubViewport/HealerBot2)
	id = Picker.get_next_id()
	Picker.register_new_pickable(id, $MainViewport/SubViewport/HealerBot3)
	id = Picker.get_next_id()
	Picker.register_new_pickable(id, $MainViewport/SubViewport/SimpleRobot)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_C:
		$MainViewport/SubViewport/VFX/Beam.switch()
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_A:
		var robot = healer_bot.get_node("robot2") as Robot2
		var basic_round_projectile = preload("res://scenes/projectile/basic_round/basic_round_projectile_sphere.tscn").instantiate() as BasicRoundProjectile
		add_child(basic_round_projectile)
		basic_round_projectile.start_pos = robot.get_source()
		var target = find_target()
		if target:
			basic_round_projectile.target = target
			basic_round_projectile.effect = func(): impact(target)
			basic_round_projectile.start()
			robot.power()

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_E:
		var robot = healer_bot.get_node("robot2") as Robot2
		var basic_round_projectile_explo = preload("res://scenes/projectile/basic_round/basic_round_projectile_explo.tscn").instantiate() as BasicRoundProjectile
		add_child(basic_round_projectile_explo)
		basic_round_projectile_explo.start_pos = robot.get_source()
		var target = find_target()
		if target:
			basic_round_projectile_explo.target = target
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
