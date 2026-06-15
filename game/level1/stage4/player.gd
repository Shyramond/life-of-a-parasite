extends Line2D

signal death(reason)

var speed = 50
var health = 100
var curve_width = []
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
	dir = dir.normalized()
	if mouse_movement:
		var distance = get_global_mouse_position() - to_global(points[0])
		dir = distance.normalized()
		if distance.length() <= 50:
			dir *= distance.length() / 50
	var velocity = dir * speed
	points[0] += velocity * delta
	points[0] = points[0].clamp(to_local(Vector2(0, 0)), to_local(get_viewport_rect().size))
	for i in range(1, points.size()):
		var vector = points[i] - points[i - 1]
		points[i] = points[i - 1] + vector.limit_length(5)
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
	get_node("Node2D").position = points[points.size() / 2]

func _ready() -> void:
	for i in range(points.size() * 4 - 6):
		var shape = CollisionShape2D.new()
		shape.shape = SegmentShape2D.new()
		shape.name = "CollisionShape2D" + str(i + 1)
		get_node("Area2D").add_child(shape)
	for i in range(points.size()):
		curve_width.append(width_curve.sample(float(i) / (points.size() - 1)) * width / 2)
	get_node("Area2D").area_entered.connect(hit)
	var progress_bar = get_node("Node2D/ProgressBar")
	progress_bar.add_theme_font_size_override("font_size", progress_bar.get_theme_font_size("font_size") / scale.x)
	progress_bar.size /= scale.x

func hit(_body):
	health -= 20
	get_node("Node2D/ProgressBar").value = health
	if health <= 0:
		death.emit("health4" + str(get_node("..").stage))
