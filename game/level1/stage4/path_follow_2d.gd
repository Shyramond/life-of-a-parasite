extends PathFollow2D

var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_ratio = randf() / 3 + 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += speed * delta
	speed += randi() % 20 - 10
	speed = clamp(speed, 50, 400)
