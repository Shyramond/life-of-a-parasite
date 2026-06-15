extends Node2D

signal new_stage

var stage = 1
const cells = [preload("res://level1/stage4/cell1.tscn"), preload("res://level1/stage4/cell2.tscn"), preload("res://level1/stage4/cell3.tscn")]

func _on_timer_timeout() -> void:
	var cell_index = randi() % stage
	var cell = cells[cell_index].instantiate()
	get_node("Path2D/PathFollow2D").progress_ratio = randf()
	cell.position = get_node("Path2D/PathFollow2D").position
	if cell_index == 0:
		cell.dir = Vector2(0, 1).rotated(get_node("Path2D/PathFollow2D").rotation + randf_range(-PI / 4, PI / 4))
		cell.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(func(): cell.queue_free())
	elif cell_index == 1:
		cell.get_node("PathFollow2D").dir = Vector2(0, 1).rotated(get_node("Path2D/PathFollow2D").rotation + randf_range(-PI / 4, PI / 4))
		cell.get_node("PathFollow2D/Area2D/VisibleOnScreenNotifier2D").screen_exited.connect(func(): cell.queue_free())
	elif cell_index == 2:
		cell.player = get_node("Player")
		cell.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(func(): cell.queue_free())
	get_node("Cells").add_child(cell)

func cell_delete(cell):
	cell.queue_free()

func _on_stage_timer_timeout() -> void:
	var player_position = get_node("Player").to_global(get_node("Player").points[0])
	var player_health = get_node("Player").health
	var mouse_movement = get_node("Player").mouse_movement
	var npc_script = preload("npc.gd")
	var player = null
	var scene = null
	if stage == 1:
		get_node("Player").name = "npc"
		get_node("npc").queue_free()
		player = get_node("Player2")
		scene = preload("res://level1/stage4/redia.tscn")
	elif stage == 2:
		get_node("Player").name = "npc"
		get_node("npc").set_script(npc_script)
		get_node("npc/Node2D").free()
		get_node("npc/Area2D").collision_layer = 0
		get_node("npc").set_process(true)
		player = get_node("Player3")
		scene = preload("res://level1/stage4/cercaria.tscn")
	else:
		return
	stage += 1
	player.position = player_position
	player.position = player_position
	player.name = "Player"
	player.speed = (stage - 1) * 100
	player.mouse_movement = mouse_movement
	player.process_mode = PROCESS_MODE_INHERIT
	for i in range(10):
		var npc = scene.instantiate()
		npc.set_script(npc_script)
		npc.get_node("Node2D").queue_free()
		npc.position = player_position
		npc.name = "npc" + str(stage) + str(i)
		npc.get_node("Area2D").collision_layer = 0
		add_child(npc)
	new_stage.emit()
