extends PathFollow2D

signal death(reason)
signal level_complete

var speed = 200
var stage = 1

func _process(delta: float) -> void:
	progress += speed * delta

func _on_button_pressed() -> void:
	if get_node("Area2D2").has_overlapping_areas():
		if stage == 4:
			level_complete.emit()
		else:
			stage += 1
			speed += 50
			var collision_shape = get_node("../../Area2D/CollisionShape2D")
			collision_shape.shape.size.x -= 20
			collision_shape.position.x = randi() % 300 + 400
			collision_shape.get_node("ColorRect").size.x -= 20
			collision_shape.get_node("ColorRect").position.x += 10
	else:
		death.emit("miss6")
