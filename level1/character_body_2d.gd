extends CharacterBody2D

const initial_speed = 100
const land_damage = 20

var speed = 0
var flow_dir = []
var flow_speed = []
var health = 100
var sun_damage = 0
var sun_count = 0
var cur_land_damage = 0

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
	velocity = dir.normalized() * speed
	if (!flow_dir.is_empty()):
		velocity += flow_dir[flow_dir.size() - 1] * flow_speed[flow_speed.size() - 1]
	health -= (sun_damage + cur_land_damage) * delta
	if health <= 0:
		game_over("высыхание")

	position += velocity * delta

func _ready() -> void:
	for node in get_node("/root/Node/River").get_children():
		if node.name.begins_with("RiverArea") or node.name.begins_with("Puddle"):
			node.body_entered.connect(area_entered.bind(node.flow_dir, node.flow_speed))
			node.body_exited.connect(area_exited.bind(node.flow_dir, node.flow_speed))
	for node in get_node("/root/Node/Sun").get_children():
		if node.name.begins_with("SunArea"):
			node.body_entered.connect(sun_area_entered.bind(node.damage))
			node.body_exited.connect(sun_area_exited)
	get_node("/root/Node/Ends/Freshwater").body_entered.connect(end_freshwater)
	get_node("/root/Node/Ends/Saltwater").body_entered.connect(end_saltwater)

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

func game_over(reason):
	get_node("/root/Node/CanvasLayer/Timer").stop()
	set_process_mode(PROCESS_MODE_DISABLED)
	get_node("/root/Node/CanvasLayer/Label").text = "Вы умерли. Причина: " + reason

func level_complete():
	get_node("/root/Node/CanvasLayer/Timer").stop()
	set_process_mode(PROCESS_MODE_DISABLED)
	get_node("/root/Node/CanvasLayer/Label").text = "Уровень пройден"

func _on_timer_timeout() -> void:
	game_over("время")

func end_freshwater(_body):
	level_complete()

func end_saltwater(_body):
	game_over("соленая вода")
