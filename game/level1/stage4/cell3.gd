extends Area2D

var speed = randi() % 100 + 50
var player = null

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, Color(0.8, 0, 0))

func _process(delta: float) -> void:
	var dir = (player.to_global(player.points[0]) - position).normalized()
	position += dir * speed * delta
