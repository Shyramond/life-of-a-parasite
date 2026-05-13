extends Area2D

@onready var flow_dir = (get_node("CollisionPolygon2D").polygon[1] - get_node("CollisionPolygon2D").polygon[0]).normalized()
@export var flow_speed = randi() % 30 + 70
@export var can_have_sun = true

func _ready() -> void:
	var shape = find_child("CollisionPolygon2D").polygon
	find_child("Polygon2D").polygon = shape
	find_child("Line2D").points = shape
