extends CanvasLayer

@onready var http_request = get_node("HTTPRequest")
var username = null

func _on_button_pressed() -> void:
	username = get_node("LineEdit").text
	http_request.request("http://127.0.0.1:8000/api/get_user", ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify({"username": username}))

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var info = JSON.parse_string(body.get_string_from_utf8())
	if typeof(info) != TYPE_ARRAY:
		get_node("Label").text = "Пользователь не найден"
		return
	var user = preload("user.tscn").instantiate()
	add_child(user)
	user.get_node("Back").pressed.connect(func(): user.queue_free())
	user.get_node("Username").text = username
	user.get_node("Total").text = "Экзаменационный режим\nВсего прохождений: " + str(info.size()) + "\nВсе прохождения:"
	var container = user.get_node("ScrollContainer/VBoxContainer")
	for i in info:
		var label = Label.new()
		label.text = "Смерти: " + str(int(i[0])) + " Неправильные ответы: " + str(int(i[1]))
		label.add_theme_font_size_override("font_size", 24)
		container.add_child(label)
