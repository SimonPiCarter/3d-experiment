extends Node3D

@onready var basic_round_projectile_explo = $MainViewport/SubViewport/Projectiles/BasicRoundProjectileExplo
@onready var basic_round_projectile = $MainViewport/SubViewport/Projectiles/BasicRoundProjectile
@onready var small_bot = $MainViewport/SubViewport/SmallBot
@onready var simple_robot = $MainViewport/SubViewport/SimpleRobot
@onready var healer_bot: QuadEntity = $MainViewport/SubViewport/HealerBot

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_A:
		var robot = healer_bot.get_node("robot2") as Robot2
		basic_round_projectile.start_pos = robot.get_source()
		basic_round_projectile.end_pos = small_bot.global_position
		basic_round_projectile.start()
		robot.power()

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_E:
		var robot = healer_bot.get_node("robot2") as Robot2
		basic_round_projectile_explo.start_pos = robot.get_source()
		basic_round_projectile_explo.end_pos = small_bot.global_position
		basic_round_projectile_explo.start()
		robot.attack()
