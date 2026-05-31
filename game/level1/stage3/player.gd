extends Area2D

signal death(reason)

var speed = 50
var health = 100
@onready var screen_size = get_viewport_rect().size
var color = "blue"

func _draw() -> void:
	draw_circle(Vector2(0, 0), get_node("CollisionShape2D").shape.radius, color)

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
	var velocity = dir.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2(0, 0), screen_size)

func _ready() -> void:
	area_entered.connect(hit)

func hit(body):
	if !body.name.begins_with("npc"):
		health -= 20
		if health <= 0:
			death.emit("health3" + str(get_node("..").stage))
