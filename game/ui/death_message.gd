extends Label

var messages = {
	"health": "Яйца O. felineus сохраняют жизнеспособность только во влажной среде. На суше они быстро погибают от высыхания.",
	"timeout": "Яйцо не попало в водоём. Без контакта с первым промежуточным хозяином цикл обрывается.",
	"saltwater": "Описторх — пресноводный паразит. Солёная среда для его яиц губительна."
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/Node").death_signal.connect(death)
	get_node("/root/Node").level_complete_signal.connect(level_complete)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func death(reason):
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = Color(0, 0, 0, 0.5)
	add_theme_stylebox_override("normal", new_sb)
	text = "Вы умерли.\n" + messages[reason]

func level_complete():
	text = "Уровень пройден"
