extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("new_animation")
	animation_player.advance(randf_range(0.,1.))
