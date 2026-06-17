extends Area2D

var speed = 0
var dir = Vector2(0, 0)
var move = true

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, Color(0.8, 0, 0))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func change_move():
	move = !move
	if move:
		dir = Vector2(randi() - 2**31, randi() - 2**31).normalized()
	else:
		speed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move:
		speed += 150 * delta
		position += speed * dir * delta
