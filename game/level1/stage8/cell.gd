extends CharacterBody2D

var speed = 0
var dir = Vector2(0, 0)
var same_area = false
var player = null

func _draw() -> void:
	if same_area:
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
	if player:
		var player_vector = player.points[0] - position
		if same_area and player_vector.length() < 100:
			var angle = dir.angle_to(player_vector)
			if angle > 0:
				dir = dir.rotated(min(angle, PI * delta / 2))
			else:
				dir = dir.rotated(max(angle, -PI * delta / 2))
	if collision_info:
		dir = velocity.bounce(collision_info.get_normal()).normalized()
