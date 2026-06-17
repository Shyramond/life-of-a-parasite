extends Node

var time = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	time /= 1.005
	get_node("SpawnTimer").start(time)
	cell()

func cell():
	get_node("Path2D/PathFollow2D").progress_ratio = randf()
	var cell = preload("res://level1/stage9/cell.tscn").instantiate()
	var index = randi() % 3 + 1
	var script = load("res://level1/stage9/cell" + str(index) + ".gd")
	cell.set_script(script)
	cell.position = get_node("Path2D/PathFollow2D").position
	cell.dir = Vector2(0, 1).rotated(get_node("Path2D/PathFollow2D").rotation + randf_range(-PI / 4, PI / 4))
	if index == 2:
		cell.player = get_node("Player")
	if index == 3:
		get_node("MovementTimer").timeout.connect(cell.change_move)
	cell.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(func(): cell.queue_free())
	get_node("Cells").add_child(cell)
