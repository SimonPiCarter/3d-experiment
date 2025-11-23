extends Control

func _process(delta: float) -> void:
	$Label.text = String.num_int64(Engine.get_frames_per_second())
