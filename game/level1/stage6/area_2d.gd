extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Polygon2D").polygon = get_node("CollisionPolygon2D").polygon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_body_2d_new_area(area: Variant) -> void:
	if area == 2 or name == "Area2D2" or name == "Area2D" + str(area):
		get_node("Polygon2D").color.a = 1
	else:
		get_node("Polygon2D").color.a = 0.3
