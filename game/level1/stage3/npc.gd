extends Area2D

var direction = Vector2(randi() - 2**31, randi() - 2**31).normalized()
var speed = randi() % 50 + 50
var color = "blue"

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, color)

func _process(delta: float) -> void:
	position += direction * speed * delta
