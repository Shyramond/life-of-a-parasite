extends Node2D

var speed = 200
var dir = Vector2(0, 0)
var player_detected = false

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, Color(0.8, 0, 0))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed * dir * delta
	var player = get_node("../../Player")
	if !player.stealth:
		if player_detected:
			dir = (player.position - position).normalized()
		elif randf() * 2 < delta:
			player_detected = true
	else:
		player_detected = false
