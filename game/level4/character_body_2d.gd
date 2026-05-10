extends Area2D

signal death(reason)
signal level_complete

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		position.y += 60
	if event.is_action_pressed("up"):
		position.y -= 60

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, "blue")

func _physics_process(delta: float) -> void:
	pass

func _ready() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Fish1":
		level_complete.emit()
	else:
		death.emit("health")
