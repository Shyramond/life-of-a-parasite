extends Node

var coords = [Vector2(-1200, 500), Vector2(-1200, 1000), Vector2(-700, 500), Vector2(-2000, 500)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cell_load = preload("res://level1/stage6/cell.tscn")
	for i in range(30):
		var cell = cell_load.instantiate()
		cell.name = "Cell1" + str(i)
		cell.speed = randi() % 20 + 50
		cell.dir = Vector2(randi() - 2**31, randi() - 2**31).normalized()
		cell.position = coords.pick_random()
		cell.collision_mask = 1
		cell.collision_layer = 4
		add_child(cell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_body_2d_new_area(area: Variant) -> void:
	if area == 3:
		for i in get_children():
			i.color.a = 0.3
			i.queue_redraw()
	else:
		for i in get_children():
			i.color.a = 1
			i.queue_redraw()
