extends Node2D

@onready var spine = $spine
@export var radius: int
@export var initial_speed = 140

signal death(reason)
signal level_complete

const land_damage = 20
const sun_damage = 20

var speed = initial_speed
var flow_dir = []
var flow_speed = []
var health = 100
var cur_sun_damage = 0
var sun_count = 0
var cur_land_damage = 0
var mouse_movement = false

func _unhandled_input(event):
	if event.is_action_pressed("lmb"):
		mouse_movement = !mouse_movement

func get_dir():
	var move = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	).limit_length(1)
	
	if mouse_movement:
		var distance = get_global_mouse_position() - to_global(spine.points[0])
		move = distance.limit_length(1)
		if distance.length() <= 50:
			move *= distance.length() / 50
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
	health -= (cur_sun_damage + cur_land_damage) * delta
	if health <= 0:
		death.emit("health1")
	position += velocity * delta
	var shape = get_node("Area2D/CollisionShape2D")
	get_node("Area2D").position = pts[pts.size() / 2]
	shape.rotation = -(pts[pts.size() * 2 / 3] - pts[pts.size() / 3]).angle_to(Vector2(0, 1))

func _ready() -> void:
	for i in range(spine.points.size()):
		spine.points[i] = Vector2(i * radius, 200.0)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Land":
		speed /= 4
		cur_land_damage = land_damage
	if area.name.begins_with("RiverArea") or area.name.begins_with("Puddle"):
		flow_dir.append(area.flow_dir)
		flow_speed.append(area.flow_speed)
	if area.name == "Sun":
		cur_sun_damage = sun_damage
		sun_count += 1
	if area.name == "Freshwater":
		level_complete.emit()
	if area.name == "Saltwater":
		death.emit("saltwater")

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Land":
		speed = initial_speed
		cur_land_damage = 0
	if area.name.begins_with("RiverArea") or area.name.begins_with("Puddle"):
		flow_dir.erase(area.flow_dir)
		flow_speed.erase(area.flow_speed)
	if area.name == "Sun":
		sun_count -= 1
		if sun_count == 0:
			cur_sun_damage = 0



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
