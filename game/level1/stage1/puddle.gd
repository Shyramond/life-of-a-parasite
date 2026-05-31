extends Area2D

var flow_dir = Vector2(0, 0)
var flow_speed = 0

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, Color("00b4ffff"))
