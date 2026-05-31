extends Area2D

signal death(reason)

const initial_speed = 200

var speed = 200
var health = 100
var energy = 100
var stealth = false
var cooldown = false

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
	var velocity = dir.normalized() * speed
	position += velocity * delta
	if stealth:
		energy -= delta * 10
		if energy <= 0:
			_on_button_pressed()
	else:
		health -= get_overlapping_areas().size() * 10 * delta
		energy = min(energy + delta * 5, 100)
	if health <= 0:
		death.emit("health1")

func _ready() -> void:
	pass


func _on_button_pressed() -> void:
	var button = get_node("../Button")
	if !stealth and energy >= 10 and !cooldown:
		stealth = true
		speed = 0
	elif stealth:
		stealth = false
		cooldown = true
		get_node("Timer").start()
		button.text = "cooldown"
		speed = initial_speed

func _on_timer_timeout() -> void:
	cooldown = false
	get_node("../Button").text = ""
