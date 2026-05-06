extends Area2D

@onready var flow_dir = (get_node("CollisionPolygon2D").polygon[1] - get_node("CollisionPolygon2D").polygon[0]).normalized()
@export var flow_speed = randi() % 50 + 110
@export var can_have_sun = true
