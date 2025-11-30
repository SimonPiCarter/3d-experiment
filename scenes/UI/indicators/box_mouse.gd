class_name BoxMouse extends TextureRect

func update(pointA : Vector2, pointB : Vector2) -> void:
	var point_from = Vector2(min(pointA.x, pointB.x), min(pointA.y, pointB.y))
	position = point_from
	size = Vector2(abs(pointA.x-pointB.x), abs(pointA.y-pointB.y))
	queue_redraw()
