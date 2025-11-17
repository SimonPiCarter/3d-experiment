class_name WhiteShrine extends Shrine

@export var buff : Node3D = null

func activate():
	if buff and buff.has_node("BasicWeapon"):
		var weapon = buff.get_node("BasicWeapon")
		weapon.reload = 0.9*weapon.reload
