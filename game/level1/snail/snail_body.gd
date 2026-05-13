extends Node2D

@onready var body = $body
@export var radius: int
@export var vel: int
@export var bodysize: int

var dir = Vector2(randi() - 2**31, randi() - 2**31).normalized()

func _ready():
	for i in range(body.points.size()):
		body.points[i] = Vector2(i * radius, 200.0)

func _process(delta):
	var pts = body.points
	pts[0] += dir * vel * delta
	for i in range(1, pts.size()):
		pts[i] = pts[i - 1] + (pts[i] - pts[i - 1]).limit_length(radius)
	body.points = pts
	if randi() % 1000 <= 100 * delta:
		dir = Vector2(randi() - 2**31, randi() - 2**31).normalized()
	if body.points[0].length() >= 800:
		dir = -body.points[0].normalized()
	get_node("Area2D").position = body.points[0]



"""
func _ready():
	for i in range(body.points.size()):
		body.points[i] = Vector2(i * radius, 200.0)


func get_dir():
	var move = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	).limit_length(1)
	
	if Input.is_action_pressed("lmb"):
		move = (get_global_mouse_position() - body.points[0]).limit_length(1)
	return move


func _process(delta):
	var pts = body.points
	
	pts[0] += get_dir() * vel * delta
	for i in range(1, pts.size()):
		pts[i] = pts[i - 1] + (pts[i] - pts[i - 1]).limit_length(radius)
	body.points = pts
"""
