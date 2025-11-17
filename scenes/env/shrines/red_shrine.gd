class_name RedShrine extends Shrine

@export var buff : Node3D = null

func activate():
	if buff and buff.has_node("BasicWeapon"):
		var weapon = buff.get_node("BasicWeapon")
		weapon.damage = 1.1*weapon.damage
