extends PathFollow2D

var speed = randi() % 100 + 50
var dir = Vector2(0, 0)

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("Area2D/CollisionShape2D").shape.radius, Color(0.8, 0, 0))

func _process(delta: float) -> void:
	progress += speed * delta
