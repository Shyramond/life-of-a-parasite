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
	var cell = preload("res://level3/cell.tscn").instantiate()
	cell.position = get_node("Path2D/PathFollow2D").position
	cell.speed = randi() % 30 + 100
	cell.dir = Vector2(0, 1).rotated(get_node("Path2D/PathFollow2D").rotation + randf_range(-PI / 4, PI / 4))
	cell.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(cell_delete.bind(cell))
	get_node("Cells").add_child(cell)

func cell2():
	get_node("Path2D/PathFollow2D").progress_ratio = randf()
	var path = preload("res://level3/path_2d.tscn").instantiate()
	path.position = get_node("Path2D/PathFollow2D").position
	path.rotation = get_node("Path2D/PathFollow2D").rotation - PI + randf_range(-PI / 4, PI / 4)
	path.get_node("PathFollow2D/Area2D/VisibleOnScreenNotifier2D").screen_exited.connect(cell_delete.bind(path))
	get_node("Cells").add_child(path)

func cell3():
	get_node("Path2D/PathFollow2D").progress_ratio = randf()
	var cell = preload("res://level3/cell.tscn").instantiate()
	cell.position = get_node("Path2D/PathFollow2D").position
	cell.speed = randi() % 30 + 100
	cell.follow_player = true
	cell.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(cell_delete.bind(cell))
	get_node("Cells").add_child(cell)

func cell_delete(cell):
	cell.queue_free()


func _on_stage_timer_timeout() -> void:
	get_node("Player").speed += 50 * stage
	stage += 1
