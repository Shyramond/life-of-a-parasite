extends Node

signal level_complete
signal death(reason)

var state = 0
var target = 0
var speed = 20
var time = 0.3

func _ready():
	get_node("Timer").start(randf() * 2 + 1)
	target = get_node("Player").position.y

func _process(delta):
	var player = get_node("Player")
	player.position.y -= min(player.position.y - target, delta * speed)
	if player.position.y <= 280:
		level_complete.emit()

func _on_button_pressed() -> void:
	if state == 0:
		death.emit("miss3")
	elif state == 1:
		target -= speed

func _on_timer_timeout() -> void:
	var new_stylebox = StyleBoxFlat.new()
	if state == 0:
		state = 1
		new_stylebox.bg_color = Color(0, 1, 0)
		get_node("Timer").start(time)
	else:
		state = 0
		new_stylebox.bg_color = Color(1, 0, 0)
		get_node("Timer").start(randi() % 2 + 1)
	get_node("Button").add_theme_stylebox_override("normal", new_stylebox)
	get_node("Button").add_theme_stylebox_override("hover", new_stylebox)
	get_node("Button").add_theme_stylebox_override("pressed", new_stylebox)
	get_node("Button").add_theme_stylebox_override("hover_pressed", new_stylebox)
