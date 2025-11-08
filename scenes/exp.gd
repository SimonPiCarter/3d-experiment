extends Node3D

@onready var basic_round_projectile: Node3D = $SubViewportContainer/SubViewport/Env2/BasicRoundProjectile
@onready var basic_round_projectile_explo = $SubViewportContainer/SubViewport/Env2/BasicRoundProjectileExplo
@onready var simple_robot: QuadEntity = $SubViewportContainer/SubViewport/SimpleRobot
@onready var robot_3: QuadEntity = $SubViewportContainer/SubViewport/Robot3

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_A:
		var robot = simple_robot.get_node("SimpleRobot") as SimpleRobot
		basic_round_projectile.start_pos = robot.get_source()
		basic_round_projectile.end_pos = robot_3.global_position
		basic_round_projectile.start()

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_E:
		var robot = simple_robot.get_node("SimpleRobot") as SimpleRobot
		basic_round_projectile_explo.start_pos = robot.get_source()
		basic_round_projectile_explo.end_pos = robot_3.global_position
		basic_round_projectile_explo.start()
