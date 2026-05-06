extends Label

func _process(delta: float) -> void:
	text = str(round(get_node("..").health))
