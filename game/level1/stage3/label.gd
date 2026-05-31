extends Label

func _process(delta: float) -> void:
	if "health" in get_node(".."):
		text = str(round(get_node("..").health))
