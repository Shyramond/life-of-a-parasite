extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ui_change():
	get_node("Deaths").text = "Смерти: " + str(get_node("..").deaths)
	get_node("WrongAnswers").text = "Неправильные ответы: " + str(get_node("..").wrong_answers)
