extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path_load = preload("path_2d.tscn")
	var fish1_load = preload("fish1.tscn")
	var fish_load = [preload("fish2.tscn"), preload("fish3.tscn")]
	for i in range(8):
		var path = path_load.instantiate()
		path.position.y = 540 - i * 60
		path.name = "Path" + str(i)
		add_child(path)
	var correct_fish = randi() % 3 + 5
	var fish1 = fish1_load.instantiate()
	fish1.name = "Fish1"
	get_node("Path" + str(correct_fish) + "/PathFollow2D").add_child(fish1)
	for i in range(8):
		if i != correct_fish:
			var fish = fish_load.pick_random().instantiate()
			get_node("Path" + str(i) + "/PathFollow2D").add_child(fish)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
