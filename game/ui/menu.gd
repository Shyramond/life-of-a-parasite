extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Resume").size = Vector2(140, 60)
	get_node("Restart").size = Vector2(140, 60)
	get_node("MainMenu").size = Vector2(140, 60)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
