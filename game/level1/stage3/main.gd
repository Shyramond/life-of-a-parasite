extends Node

var stage = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var cell = randi() % stage
	if cell == 0:
		cell1()
	elif cell == 1:
		cell2()
	else:
		cell3()

func cell1():
	get_node("Path2D/PathFollow2D").progress_ratio = randf()
	var cell = preload("res://level1/stage3/cell.tscn").instantiate()
	cell.position = get_node("Path2D/PathFollow2D").position
	cell.speed = randi() % 30 + 100
	cell.dir = Vector2(0, 1).rotated(get_node("Path2D/PathFollow2D").rotation + randf_range(-PI / 4, PI / 4))
	cell.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(cell_delete.bind(cell))
	get_node("Cells").add_child(cell)

func cell2():
	get_node("Path2D/PathFollow2D").progress_ratio = randf()
	var path = preload("res://level1/stage3/path_2d.tscn").instantiate()
	path.position = get_node("Path2D/PathFollow2D").position
	path.rotation = get_node("Path2D/PathFollow2D").rotation - PI + randf_range(-PI / 4, PI / 4)
	path.get_node("PathFollow2D/Area2D/VisibleOnScreenNotifier2D").screen_exited.connect(cell_delete.bind(path))
	get_node("Cells").add_child(path)

func cell3():
	get_node("Path2D/PathFollow2D").progress_ratio = randf()
	var cell = preload("res://level1/stage3/cell.tscn").instantiate()
	cell.position = get_node("Path2D/PathFollow2D").position
	cell.speed = randi() % 30 + 100
	cell.follow_player = true
	cell.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(cell_delete.bind(cell))
	get_node("Cells").add_child(cell)

func cell_delete(cell):
	cell.queue_free()

func _on_stage_timer_timeout() -> void:
	stage += 1
	var color = "green"
	var player_position = get_node("Player").position
	var player_health = get_node("Player").health
	var npc_script = preload("res://level1/stage3/npc.gd")
	var player = null
	if stage == 2:
		get_node("Player").name = "npc"
		get_node("npc").queue_free()
		player = get_node("Player2")
	elif stage == 3:
		get_node("Player").name = "npc"
		get_node("npc").set_script(npc_script)
		get_node("npc/Label").free()
		get_node("npc").set_process(true)
		color = "yellow"
		player = get_node("Player3")
	else:
		return
	player.position = player_position
	player.color = color
	player.position = player_position
	player.name = "Player"
	player.speed = (stage - 1) * 100
	player.health = player_health
	player.process_mode = PROCESS_MODE_INHERIT
	player.queue_redraw()
	var scene = load("res://level1/stage3/character_body_2d" + str(stage) + ".tscn")
	for i in range(10):
		var npc = scene.instantiate()
		npc.set_script(npc_script)
		npc.color = color
		npc.get_node("Label").queue_free()
		npc.position = player_position
		npc.name = "npc" + str(stage) + str(i)
		add_child(npc)
