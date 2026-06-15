extends Line2D

signal death(reason)
signal level_complete
var target = 610
var speed = 200

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		target += 60
	if event.is_action_pressed("up"):
		target -= 60
	target = clamp(target, 130, 610)

func _physics_process(delta: float) -> void:
	var diff = target - position.y
	if diff < 0:
		position.y += max(diff, -speed * delta)
		rotation = PI / 2
		get_node("Label").rotation = -PI / 2
	elif diff > 0:
		position.y += min(diff, speed * delta)
		rotation = -PI / 2
		get_node("Label").rotation = PI / 2

func _ready() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Fish1":
		level_complete.emit()
	else:
		death.emit("fish")

func _on_up_pressed() -> void:
	target -= 60
	target = clamp(target, 130, 610)

func _on_down_pressed() -> void:
	target += 60
	target = clamp(target, 130, 610)
