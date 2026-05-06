extends Area2D

const freshwater = ["Озеро", "Река", "Пруд"]
const saltwater = ["Море", "Океан"]

func _ready() -> void:
	get_node("Label").text = freshwater.pick_random() if name == "Freshwater" else saltwater.pick_random()
