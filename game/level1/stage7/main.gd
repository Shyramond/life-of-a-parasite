extends Node

var coords = [Vector2(-250, 1000), Vector2(-400, -300), Vector2(250, 1000)]

func _ready() -> void:
	var cell_load = preload("res://level1/stage7/cell.tscn")
	for i in range(150):
		var cell = cell_load.instantiate()
		cell.name = "Cell1" + str(i)
		cell.speed = randi() % 20 + 50
		cell.dir = Vector2(randi() - 2**31, randi() - 2**31).normalized()
		cell.position = coords.pick_random()
		cell.position.x = randi() % 600 - 1600
		cell.position.y = randi() % 1400 + 400
		cell.collision_mask = 1
		cell.collision_layer = 4
		get_node("Area2D1").add_child(cell)
	for i in range(40):
		var cell = cell_load.instantiate()
		cell.name = "Cell2" + str(i)
		cell.speed = randi() % 20 + 50
		cell.dir = Vector2(randi() - 2**31, randi() - 2**31).normalized()
		cell.position = coords.pick_random()
		cell.collision_mask = 2
		cell.collision_layer = 8
		get_node("Area2D3").add_child(cell)
	get_node("Player/Area2D").area_entered.connect(get_node("Area2D1")._on_character_body_2d_new_area)
	get_node("Player/Area2D").area_entered.connect(get_node("Area2D3")._on_character_body_2d_new_area)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
