extends Node2D

var speed = 0
var dir = Vector2(0, 0)
var follow_player = false

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, "red")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed * dir * delta
	if follow_player:
		dir = (get_node("../../Player").position - position).normalized()
