extends Area2D

signal death(reason)
signal level_complete

var speed = 50
var health = 100
@onready var screen_size = get_viewport_rect().size

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, "blue")

func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	var velocity = dir.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2(0, 0), screen_size)

func _ready() -> void:
	area_entered.connect(hit)

func hit(_body):
	health -= 10
	if health <= 0:
		death.emit("health")
