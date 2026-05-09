extends Node

func get_size(polygon):
	return (polygon[1] - polygon[0]).length()

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var scene_load = preload("res://level1/sun.tscn")
	var river_areas = get_node("../River").get_children()
	river_areas = river_areas.filter(func(elem): return elem.name.begins_with("RiverArea") and elem.can_have_sun)
	var weights = river_areas.map(func(elem): return get_size(elem.find_child("CollisionPolygon2D").polygon))
	for i in range(150):
		var shape = river_areas[rng.rand_weighted(weights)].find_child("CollisionPolygon2D").polygon
		var rand_point = shape[0] + (shape[1] - shape[0]) * randf() + (shape[2] - shape[1]) * randf()
		var scene = scene_load.instantiate()
		scene.name = "SunArea" + str(i)
		scene.position = rand_point
		add_child(scene)
