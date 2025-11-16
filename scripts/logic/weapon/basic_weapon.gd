class_name BasicWeapon extends Node

@export var projectile : PackedScene = null
@export var reload : float = 2.
@export var source : Node3D = null
@export var targets : Node3D = null
@export var root_projectile : Node = null

var elapsed = 0.

func _process(delta: float) -> void:
	elapsed += delta
	if elapsed > reload:
		var robot = source.get_node("robot2") as Robot2
		var target = find_target()
		var basic_round_projectile = projectile.instantiate() as BasicRoundProjectile
		root_projectile.add_child(basic_round_projectile)
		basic_round_projectile.start_pos = robot.get_source()
		if target:
			basic_round_projectile.target = target
			basic_round_projectile.effect = func(): impact(target)
			basic_round_projectile.start()
			robot.attack()
			elapsed = 0.

func find_target() -> Robot3:
	var min_dist = -1.
	var best = null
	for child in targets.get_children():
		if not child.dead:
			var dist = (child.global_position - source.global_position).length()
			if dist < min_dist or min_dist < 0.:
				best = child
				min_dist = dist
	return best

func impact(target):
	if not target.dead:
		target.health.damage(1.)
