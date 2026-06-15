extends Line2D

var dir = Vector2(randi() - 2**31, randi() - 2**31).normalized()
var speed = randi() % 50 + 50

func _process(delta: float) -> void:
	points[0] += dir * speed * delta
	for i in range(1, points.size()):
		points[i] = points[i - 1] + (points[i] - points[i - 1]).limit_length(5)
