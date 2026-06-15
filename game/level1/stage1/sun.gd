extends Area2D

const radius = 20

func _draw() -> void:
	for i in get_children():
		draw_circle(i.position, radius, "yellow")

func get_size(polygon):
	return (polygon[1] - polygon[0]).length()

func random_point(polygon):
	var a = randf()
	var b = randf()
	if a + b > 1:
		a = 1 - a
		b = 1 - b
	var vector1 = polygon[1] - polygon[0]
	var vector2 = polygon[2] - polygon[1]
	var vector3 = polygon[3] - polygon[2]
	var vector4 = polygon[0] - polygon[3]
	if round(randf()):
		return polygon[0] + vector1 * a - vector4 * b
	else:
		return polygon[2] + vector3 * a - vector2 * b

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var river_areas = get_node("../River").get_children()
	river_areas = river_areas.filter(func(elem): return elem.name.begins_with("RiverArea") and elem.can_have_sun)
	var weights = river_areas.map(func(elem): return get_size(elem.find_child("CollisionPolygon2D").polygon))
	for i in range(100):
		var shape = river_areas[rng.rand_weighted(weights)].find_child("CollisionPolygon2D").polygon
		var side1 = (shape[1] - shape[0]).normalized()
		var side2 = (shape[2] - shape[1]).normalized()
		var side3 = (shape[3] - shape[2]).normalized()
		var side4 = (shape[0] - shape[3]).normalized()
		var dir1 = (side1 - side4).normalized()
		var dir2 = (side2 - side1).normalized()
		var dir3 = (side3 - side2).normalized()
		var dir4 = (side4 - side3).normalized()
		shape[0] += dir1 * (radius / sin(abs(dir1.angle_to(side1))))
		shape[1] += dir2 * (radius / sin(abs(dir2.angle_to(side2))))
		shape[2] += dir3 * (radius / sin(abs(dir3.angle_to(side3))))
		shape[3] += dir4 * (radius / sin(abs(dir4.angle_to(side4))))
		var rand_point = random_point(shape)
		var scene = CollisionShape2D.new()
		scene.shape = CircleShape2D.new()
		scene.shape.radius = 20
		scene.position = rand_point
		add_child(scene)
