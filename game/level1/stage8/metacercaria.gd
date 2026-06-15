extends Line2D

signal death(reason)
signal level_complete

var speed = 200
var health = 100
var curve_width = []
var radius = (points[1] - points[0]).length()
var mouse_movement = false

func _unhandled_input(input):
	if input.is_action_pressed("lmb"):
		mouse_movement = !mouse_movement

func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if mouse_movement:
		var distance = get_global_mouse_position() - to_global(points[0])
		dir = distance.normalized()
		if distance.length() <= 50:
			dir *= distance.length() / 50
	var velocity = dir.normalized() * speed
	var body = get_node("CharacterBody2D1")
	body.velocity = velocity
	body.move_and_slide()
	points[0] += body.position
	body.position = Vector2(0, 0)
	for i in range(1, points.size()):
		var vector = points[i] - points[i - 1]
		if i == points.size() - 1:
			points[i] = points[i - 1] + vector.limit_length(radius)
		else:
			body = get_node("CharacterBody2D" + str(i + 1))
			body.velocity = (vector.limit_length(radius) - vector) / delta
			var collision = body.move_and_collide(body.velocity * delta)
			points[i] += body.position
			body.position = Vector2(0, 0)
			if collision:
				var normal = collision.get_normal()
				var movement_dir = normal.orthogonal()
				var angle = abs(movement_dir.angle_to(points[i - 1] - points[i]))
				if angle > PI / 2:
					movement_dir *= -1
					angle = abs(movement_dir.angle_to(points[i - 1] - points[i]))
				var side1 = (points[i - 1] - points[i]).length()
				var a = radius**2 - side1**2*sin(angle)**2
				if a > 0:
					points[i] += movement_dir * (side1 * cos(angle) - sqrt(a))
				else:
					points[i] = points[i - 1] + normal * radius
		vector = vector.orthogonal().normalized()
		var position1 = points[i - 1] + vector * curve_width[i - 1]
		var position2 = points[i - 1] - vector * curve_width[i - 1]
		var position3 = points[i] + vector * curve_width[i]
		var position4 = points[i] - vector * curve_width[i]
		if i != 1:
			get_node("Area2D/CollisionShape2D" + str((i - 1) * 4 - 1)).shape.b = position1
			get_node("Area2D/CollisionShape2D" + str((i - 1) * 4)).shape.b = position2
		get_node("Area2D/CollisionShape2D" + str((i - 1) * 4 + 1)).shape.a = position1
		get_node("Area2D/CollisionShape2D" + str((i - 1) * 4 + 2)).shape.a = position2
		get_node("Area2D/CollisionShape2D" + str((i - 1) * 4 + 1)).shape.b = position3
		get_node("Area2D/CollisionShape2D" + str((i - 1) * 4 + 2)).shape.b = position4
		if i != points.size() - 1:
			get_node("Area2D/CollisionShape2D" + str((i - 1) * 4 + 3)).shape.a = position3
			get_node("Area2D/CollisionShape2D" + str((i - 1) * 4 + 4)).shape.a = position4
	get_node("Camera2D").position = points[0]
	get_node("Node2D").position = points[points.size() / 2]

func _ready() -> void:
	var shapes = []
	for i in range(points.size() * 4 - 6):
		var collision_shape = CollisionShape2D.new()
		var shape = SegmentShape2D.new()
		shapes.append(shape)
		collision_shape.shape = shape
		collision_shape.name = "CollisionShape2D" + str(i + 1)
		get_node("Area2D").add_child(collision_shape)
	for i in range(points.size() - 1):
		var body = CharacterBody2D.new()
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shapes[max(0, i * 4 - 2)]
		body.add_child(collision_shape)
		collision_shape = CollisionShape2D.new()
		collision_shape.shape = shapes[max(1, i * 4 - 1)]
		body.add_child(collision_shape)
		body.name = "CharacterBody2D" + str(i + 1)
		body.position = points[i]
		body.collision_layer = 0
		add_child(body)
	for i in range(points.size()):
		curve_width.append(width_curve.sample(float(i) / (points.size() - 1)) * width / 2)

func _on_area_exited(area: Area2D) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.name.begins_with("Area2D"):
		var bodies_collision = 0
		if area.name == "Area2D2":
			bodies_collision = 1 | 2
			get_node("Area2D").collision_mask = 4 | 8 | 1 | 2
		if area.name == "Area2D1":
			bodies_collision= 1
			get_node("Area2D").collision_mask = 4 | 1
		if area.name == "Area2D3":
			bodies_collision = 2
			get_node("Area2D").collision_mask = 8 | 2
		for i in get_children():
			if i.name.begins_with("CharacterBody2D"):
				i.collision_mask = bodies_collision
	if area.name == "End1" or area.name == "End2" or area.name == "End3":
		level_complete.emit()
	if area.name == "End4":
		death.emit("digestion")

func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Cell"):
		health -= 10
		speed /= 1.1
		get_node("Node2D/ProgressBar").value = health
	if health <= 0:
		death.emit("health8")
