extends Button

func _on_player_button_change(state: Variant) -> void:
	if state == 0:
		text = "Маскировка"
	elif state == 1:
		text = "Маскировка (активировано)"
	elif state == 2:
		text = "Перезагрузка"
