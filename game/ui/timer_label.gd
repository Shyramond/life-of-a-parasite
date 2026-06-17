extends Label

var level8 = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if level8:
		time += delta
		text = "Время: " + str(int(round(time)))
	else:
		text = "Оставшееся время: " + str(int(round(get_node("..").time_left)))
