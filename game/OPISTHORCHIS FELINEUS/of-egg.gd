extends Node2D

@onready var spine = $spine
@export var radius: int
@export var initial_speed = 140

signal death(reason)
signal level_complete

const land_damage = 20

var speed = 0
var flow_dir = []
var flow_speed = []
var health = 100
var sun_damage = 0
var sun_count = 0
var cur_land_damage = 0
var mouse_movement = false

func _unhandled_input(input):
	if input is InputEventMouseButton and input.pressed:
		if input.button_index == MOUSE_BUTTON_LEFT:
			mouse_movement = !mouse_movement

func get_dir():
	var move = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	).limit_length(1)
	
	if mouse_movement:
		var distance = get_global_mouse_position() - to_global(spine.points[0])
		move = distance.limit_length(1)
		if distance.length() <= 100:
			move *= distance.length() / 100
	return move

func _physics_process(delta: float) -> void:
	var pts = spine.points
	var dir = get_dir()
	pts[0] += dir * speed * delta
	
	for i in range(1, pts.size()):
		pts[i] = pts[i - 1] + (pts[i] - pts[i - 1]).limit_length(radius)
	spine.points = pts

	var velocity = Vector2(0, 0)
	if !flow_dir.is_empty():
		velocity = flow_dir[flow_dir.size() - 1] * flow_speed[flow_speed.size() - 1]
	health -= (sun_damage + cur_land_damage) * delta
	if health <= 0:
		death.emit("health")
	position += velocity * delta
	var shape = get_node("Area2D/CollisionShape2D")
	get_node("Area2D").position = pts[pts.size() / 2]
	shape.rotation = -(pts[pts.size() * 2 / 3] - pts[pts.size() / 3]).angle_to(Vector2(0, 1))

func _ready() -> void:
	for i in range(spine.points.size()):
		spine.points[i] = Vector2(i * radius, 200.0)

	for node in get_node("../River").get_children():
		if node.name.begins_with("RiverArea"):
			node.body_entered.connect(area_entered.bind(node.flow_dir, node.flow_speed))
			node.body_exited.connect(area_exited.bind(node.flow_dir, node.flow_speed))
	for node in get_node("../Puddles").get_children():
		if node.name.begins_with("Puddle"):
			node.body_entered.connect(area_entered.bind(node.flow_dir, node.flow_speed))
			node.body_exited.connect(area_exited.bind(node.flow_dir, node.flow_speed))
	for node in get_node("../Sun").get_children():
		if node.name.begins_with("SunArea"):
			node.body_entered.connect(sun_area_entered.bind(node.damage))
			node.body_exited.connect(sun_area_exited)
	get_node("../Ends/Freshwater").body_entered.connect(end_freshwater)
	get_node("../Ends/Saltwater").body_entered.connect(end_saltwater)

func area_entered(_body, flow_dir1, flow_speed1):
	speed = initial_speed
	cur_land_damage = 0
	flow_dir.append(flow_dir1)
	flow_speed.append(flow_speed1)

func area_exited(_body, flow_dir1, flow_speed1):
	flow_dir.erase(flow_dir1)
	flow_speed.erase(flow_speed1)
	if flow_dir.is_empty():
		speed /= 4
		cur_land_damage = land_damage

func sun_area_entered(_body, damage):
	sun_damage = damage
	sun_count += 1

func sun_area_exited(_body):
	sun_count -= 1
	if sun_count == 0:
		sun_damage = 0

func end_freshwater(_body):
	level_complete.emit()

func end_saltwater(_body):
	death.emit("saltwater")




"""
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


func _process(delta):
	var pts = spine.points
	
	pts[0] += get_dir() * vel * delta
	
	for i in range(1, pts.size()):
		pts[i] = pts[i - 1] + (pts[i] - pts[i - 1]).limit_length(radius)
	spine.points = pts
"""
