extends CharacterBody2D

var speed = 0
var dir = Vector2(0, 0)
#var color = Color(0.8, 0, 0, 1)

func _draw() -> void:
	var parent = get_node("..")
	if parent.cur_area == "Area2D2" or parent.name == "Area2D2" or parent.name == parent.cur_area:
		draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, Color(0.8, 0, 0, 1))
	else:
		draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, Color(0.8, 0, 0, 0.3))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = speed * dir
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		dir = velocity.bounce(collision_info.get_normal()).normalized()
