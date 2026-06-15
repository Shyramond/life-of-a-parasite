extends Node

signal level_complete()
signal death(reason)

var correct = [
	"Холодное копчение при температуре 30 С в течении 2 часов",
	"Жарить на углях 7 минут",
	"Маринование",
	"Быстрый посол",
	"Заморозить, затем съесть сырой",
	"Вяление"
]

var incorrect = [
	"Варить 20 минут",
	"Горячее копчение при температуре 90 С в течении 2 часов",
	"Печь в духовке 60 минут при температуре 180 С",
	"Посол на 30 суток"
]

var correct_index = randi() % correct.size()
var incorrect_index = randi() % incorrect.size()

func _ready() -> void:
	var rand_num = round(randf())
	get_node("Button").name = "Correct" if rand_num else "Incorrect"
	get_node("Button2").name = "Correct" if !rand_num else "Incorrect"
	get_node("Correct").text = correct[correct_index]
	get_node("Incorrect").text = incorrect[incorrect_index]
	get_node("Correct").pressed.connect(correct_button)
	get_node("Incorrect").pressed.connect(incorrect_button)

func correct_button():
	level_complete.emit()

func incorrect_button():
	death.emit("button" + str(incorrect_index))
