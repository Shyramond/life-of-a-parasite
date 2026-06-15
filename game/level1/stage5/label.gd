extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var parent_scale = get_parent().scale
	scale = Vector2(1.0 / parent_scale.x, 1.0 / parent_scale.y)
