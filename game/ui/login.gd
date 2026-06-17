extends CanvasLayer

signal success(username, password)

@onready var http_request = get_node("HTTPRequest")
var username = 0
var password = 0
var sent = false

func request(type):
	if sent:
		return
	username = get_node("VBoxContainer/Username").text
	password = get_node("VBoxContainer/Password").text
	if username.length() < 3 or password.length() < 3:
		get_node("Label").text = "Длина никнейма и пароля должна быть как минимум 3 символа"
		return
	var data = {
		"username": username,
		"password": password
	}
	http_request.request("http://127.0.0.1:8000/api/" + type, ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(data))
	sent = true

func _on_register_pressed() -> void:
	request("add_user")

func _on_login_pressed() -> void:
	request("login")

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var code = JSON.parse_string(body.get_string_from_utf8())
	if code == 1:
		get_node("Label").text = "Никнейм занят"
		sent = false
	elif code == 3:
		get_node("Label").text = "Неверный никнейм или пароль"
		sent = false
	else:
		success.emit(username, password)
