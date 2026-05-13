extends Node2D

func _draw() -> void:
	draw_circle(get_node("../CollisionShape2D").transform.origin, get_node("../CollisionShape2D").shape.radius, "blue")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
