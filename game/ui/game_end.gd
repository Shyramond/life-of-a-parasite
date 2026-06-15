extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Игра пройдена\nСмерти: " + str(get_node("../..").deaths) + "\nНеправильные ответы: " + str(get_node("../..").wrong_answers) + "\nВремя выживания на стадии марита: " + str(snapped(get_node("../../ui/Timer/TimerLabel").time, 0.01))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
