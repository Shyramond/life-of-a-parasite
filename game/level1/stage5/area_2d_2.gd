extends Area2D

signal death(reason)
signal level_complete

var speed = 150
var stage = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("..").progress += speed * delta


func _on_button_pressed() -> void:
	if has_overlapping_areas():
		if stage == 4:
			level_complete.emit()
		else:
			stage += 1
			speed += 50
			get_node("../../../Area2D/CollisionShape2D").shape.size.x -= 20
			get_node("../../../Area2D/CollisionShape2D/ColorRect").size.x -= 20
			get_node("../../../Area2D/CollisionShape2D/ColorRect").position.x += 10
	else:
		death.emit("health")
