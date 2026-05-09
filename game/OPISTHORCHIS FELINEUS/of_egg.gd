extends Node2D

@onready var spine = $spine
@export var radius: int
@export var vel: int

var health = 100

func _ready():
	for i in range(spine.points.size()):
		spine.points[i] = Vector2(i * radius, 200.0)


func get_dir():
	var move = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	).limit_length(1)
	
	if Input.is_action_pressed("lmb"):
		move = (get_global_mouse_position() - spine.points[0]).limit_length(1)
	return move


func _physics_process(delta):
	var pts = spine.points
	
	pts[0] += get_dir() * vel * delta
	
	for i in range(1, pts.size()):
		pts[i] = pts[i - 1] + (pts[i] - pts[i - 1]).limit_length(radius)
	spine.points = pts
	
	get_node("Area2D").position = pts[pts.size() / 2]
	get_node("Area2D/CollisionShape2D").rotation = -(pts[pts.size() * 2 / 3] - pts[pts.size() / 3]).angle_to(Vector2(0, 1))
