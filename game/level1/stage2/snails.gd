extends Node

var max_distance = 1000
var count = 40

func snail_instantiate(snail1, name1):
	var snail = snail1.instantiate()
	snail.name = name1
	var distance = randi() % (max_distance - 200) + 200
	var angle = randi() % 360
	snail.position = Vector2(distance * sin(angle), distance * cos(angle))
	snail.max_distance = max_distance
	add_child(snail)
	#snail.get_node("Area2D2").input_event.connect(input_event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bith = preload("res://level1/snail/Bithynia/bith.tscn")
	var lym = preload("res://level1/snail/Lymnaea/lym.tscn")
	var plan = preload("res://level1/snail/Planorbis/plan.tscn")
	var vivi = preload("res://level1/snail/Viviparus/vivi.tscn")
	snail_instantiate(bith, "Bith")
	var arr = {"Lymn": lym, "Plan": plan, "Vivi": vivi}
	for i in range(count):
		var random = arr.keys().pick_random()
		snail_instantiate(arr[random], random + str(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
