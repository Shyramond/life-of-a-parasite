extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	cell()

func cell():
	get_node("Path2D/PathFollow2D").progress_ratio = randf()
	var cell = preload("res://level1/stage8/cell.tscn").instantiate()
	cell.position = get_node("Path2D/PathFollow2D").position
	cell.dir = Vector2(0, 1).rotated(get_node("Path2D/PathFollow2D").rotation + randf_range(-PI / 4, PI / 4))
	get_node("Cells").add_child(cell)
