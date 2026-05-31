extends Area2D

var cur_area = "Area2D1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_body_2d_new_area(area: Variant) -> void:
	cur_area = area.name
	for i in get_children():
		if i.name.begins_with("Cell"):
			i.queue_redraw()
	if area.name == "Area2D2" or name == area.name:
		get_node("Polygon2D").color.a = 1
	else:
		get_node("Polygon2D").color.a = 0.3


func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Cell"):
		body.call_deferred("reparent", self, true)
		body.queue_redraw()
		if name == "Area2D1":
			body.collision_mask = 1
			body.collision_layer = 4
		elif name == "Area2D2":
			body.collision_mask = 1 | 2
			body.collision_layer = 4 | 8
		else:
			body.collision_mask = 2
			body.collision_layer = 8
