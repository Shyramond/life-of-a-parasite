extends Node

func _ready() -> void:
	var end_top = preload("res://level1/end_top.tscn").instantiate()
	var end_bottom = preload("res://level1/end_bottom.tscn").instantiate()
	var rand_num = round(randf())
	end_top.name = "Freshwater" if rand_num else "Saltwater"
	end_bottom.name = "Saltwater" if rand_num else "Freshwater"
	add_child(end_top)
	add_child(end_bottom)
