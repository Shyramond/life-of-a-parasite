extends Node

const freshwater = ["Озеро", "Река", "Пруд"]
const saltwater = ["Море", "Океан"]

func _ready() -> void:
	var rand_num = round(randf())
	get_node("Top").name = "Freshwater" if rand_num else "Saltwater"
	get_node("Bottom").name = "Freshwater" if !rand_num else "Saltwater"
	get_node("Freshwater/ColorRect/Label").text = freshwater.pick_random()
	get_node("Saltwater/ColorRect/Label").text = saltwater.pick_random()
