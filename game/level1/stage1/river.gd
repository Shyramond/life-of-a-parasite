extends Node

func _ready() -> void:
	var puddle_scene = preload("puddle.tscn")
	var area_names = ["RiverArea3", "RiverArea21", "RiverArea30", "RiverArea31"]
	for i in area_names:
		if round(randf()):
			var shape = get_node(str(i) + "/CollisionPolygon2D").polygon
			#var shape = get_node(i).find_child("CollisionPolygon2D").polygon
			var pos = (shape[0] + shape[3]) / 2
			var puddle = puddle_scene.instantiate()
			puddle.name = "Puddle" + str(i)
			puddle.position = pos
			get_node(str(i)).free()
			get_node("../Puddles").add_child(puddle)
