extends Node

func snail_instantiate(snail1, name1):
	var snail = snail1.instantiate()
	snail.name = name1
	while (snail.position.length() <= 200):
		snail.position = Vector2(randi() % 1000 - 500, randi() % 1000 - 500)
	add_child(snail)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bith = preload("res://snail/Bithynia/bith.tscn")
	var lym = preload("res://snail/Lymnaea/lym.tscn")
	var plan = preload("res://snail/Planorbis/plan.tscn")
	var vivi = preload("res://snail/Viviparus/vivi.tscn")
	snail_instantiate(bith, "Bith")
	var arr = [lym, plan, vivi]
	for i in range(20):
		snail_instantiate(arr.pick_random(), str(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
