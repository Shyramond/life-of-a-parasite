extends CharacterBody2D

signal death(reason)
signal level_complete

var speed = 200
var health = 100

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, "blue")

func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	velocity = dir.normalized() * speed
	move_and_slide()

func _ready() -> void:
	pass

func _on_area_exited(area: Area2D) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Area2D2":
		collision_mask = 1 | 2
		get_node("Area2D").collision_mask = 4 | 8 | 1 | 2
	if area.name == "Area2D1":
		collision_mask = 1
		get_node("Area2D").collision_mask = 4 | 1
	if area.name == "Area2D3":
		collision_mask = 2
		get_node("Area2D").collision_mask = 8 | 2
	if area.name == "End1" or area.name == "End2" or area.name == "End3":
		level_complete.emit()
	if area.name == "End4":
		death.emit("digestion")

func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Cell"):
		health -= 10
		speed /= 1.5
		#var timer = preload("res://level1/stage7/timer.tscn").instantiate()
		#timer.timeout.connect(timeout)
		#add_child(timer)
	if health <= 0:
		death.emit("health6")

func timeout():
	speed *= 2
