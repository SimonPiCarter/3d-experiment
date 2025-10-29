extends MeshInstance3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_W and event.is_pressed():
		animation_player.play("fire")
