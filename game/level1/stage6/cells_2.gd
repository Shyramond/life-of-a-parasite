extends Node

var coords = [Vector2(-250, 1000), Vector2(-400, -300)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cell_load = preload("res://level1/stage6/cell.tscn")
	for i in range(20):
		var cell = cell_load.instantiate()
		cell.name = "Cell2" + str(i)
		cell.speed = randi() % 20 + 50
		cell.dir = Vector2(randi() - 2**31, randi() - 2**31).normalized()
		cell.position = coords.pick_random()
		cell.collision_mask = 2
		cell.collision_layer = 8
		add_child(cell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_body_2d_new_area(area: Variant) -> void:
	if area == 1:
		for i in get_children():
			i.color.a = 0.3
			i.queue_redraw()
	else:
		for i in get_children():
			i.color.a = 1
			i.queue_redraw()
