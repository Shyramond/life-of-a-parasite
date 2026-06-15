extends CanvasLayer

signal correct
signal incorrect

@onready var index = get_node("..").cur_stage - 1

const question = [
	"Первая стадия жизненного цикла кошачей двуустки - это",
	"Вторая стадия жизненного цикла кошачей двуустки - это",
	"Третья стадия жизненного цикла кошачей двуустки - это",
	"Четвертая стадия жизненного цикла кошачей двуустки - это",
	"Пятая стадия жизненного цикла кошачей двуустки - это",
	"Шестая стадия жизненного цикла кошачей двуустки - это",
	"Седьмая стадия жизненного цикла кошачей двуустки - это"
]

const answers = [
	"Яйцо",
	"Мирацидий",
	"Спороциста",
	"Редия",
	"Церкария",
	"Метацеркария",
	"Марита"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var answers_copy = answers.duplicate()
	answers_copy.shuffle()
	get_node("ColorRect/Label").text = question[index]
	for i in range(4):
		get_node("ColorRect/HBoxContainer/Button" + str(i + 1)).text = answers_copy[i]
	for i in range(3):
		get_node("ColorRect/HBoxContainer2/Button" + str(i + 1)).text = answers_copy[4 + i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed(node_path) -> void:
	if get_node(node_path).text == answers[index]:
		correct.emit()
	else:
		incorrect.emit()
		var new_stylebox = StyleBoxFlat.new()
		new_stylebox.bg_color = Color(1, 0, 0)
		var hover_stylebox = StyleBoxFlat.new()
		hover_stylebox.bg_color = Color(0.8, 0, 0)
		get_node(node_path).add_theme_stylebox_override("normal", new_stylebox)
		get_node(node_path).add_theme_stylebox_override("hover", hover_stylebox)
