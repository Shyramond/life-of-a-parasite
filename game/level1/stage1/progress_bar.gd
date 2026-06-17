extends ProgressBar

func _process(delta: float) -> void:
	value = int(round(get_node("../..").health))
