extends Node

signal ui_change
signal question_closed

const level_time = [70, 40, 15, 60, 30, 30, 20, 50, 60]

var deaths = 0
var wrong_answers = 0
var cur_level = 1
var cur_stage = 1
var mode = 0
var username = null
var password = null

func _ready() -> void:
	ui_add("main_menu")

func _process(delta: float) -> void:
	pass

func signal_connect(level):
	if cur_level == 3 or cur_level == 7:
		level.level_complete.connect(level_complete)
		level.death.connect(death)
	elif cur_level == 4:
		level.get_node("Player").death.connect(death)
		level.get_node("Player2").death.connect(death)
		level.get_node("Player3").death.connect(death)
		level.new_stage.connect(func(): cur_stage += 1; ui_add("questions"))
	elif cur_level == 6:
		level.get_node("Path2D/PathFollow2D").death.connect(death)
		level.get_node("Path2D/PathFollow2D").level_complete.connect(level_complete)
	elif cur_level == 9:
		level.get_node("Player").death.connect(death)
	else:
		level.get_node("Player").death.connect(death)
		level.get_node("Player").level_complete.connect(level_complete)

func level_load():
	if has_node("Level"):
		get_node("Level").name = "Level2"
		get_node("Level2").queue_free()
	var level = load("res://level1/stage" + str(cur_level) + "/main.tscn").instantiate()
	level.name = "Level"
	call_deferred("add_child", level)
	call_deferred("move_child", level, 0)
	signal_connect(level)
	get_tree().paused = false
	get_node("ui/Timer").wait_time = level_time[cur_level - 1]
	get_node("ui/Timer").start()
	if cur_level == 2:
		cur_stage = 1
	elif cur_level == 3:
		cur_stage = 2
	elif cur_level == 4:
		cur_stage = 3
	elif cur_level == 7:
		cur_stage = 6
	elif cur_level == 9:
		cur_stage = 7
		get_node("ui/Timer/TimerLabel").level8 = true

func restart():
	deaths += 1
	ui_remove("menu")
	ui_change.emit()
	level_load()

func death(reason):
	if cur_level == 9:
		ui_add("game_end")
		save_game()
	else:
		ui_add("death_message", reason)
		get_tree().paused = true
		await get_tree().create_timer(3.0).timeout
		ui_remove("death_message")
		get_tree().paused = false
		deaths += 1
		ui_change.emit()
		level_load()

func level_complete():
	get_tree().paused = true
	get_node("Level").name = "Level2"
	get_node("Level2").queue_free()
	if cur_level != 9:
		cur_level += 1
	level_load()
	if mode == 0:
		ui_add("story")
	elif cur_level != 2 and cur_level != 5 and cur_level != 6 and cur_level != 8:
		ui_add("questions")

func timeout():
	if cur_level == 4:
		level_complete()
	elif cur_level != 9:
		death("timeout" + str(cur_level))

func game_start():
	ui_remove("main_menu")
	ui_add("ui")
	level_load()
	if mode == 0:
		ui_add("story")
	elif cur_level != 2 and cur_level != 5 and cur_level != 6 and cur_level != 8:
		ui_add("questions")

func ui_remove(ui):
	get_node(ui).queue_free()
	get_tree().paused = false
	if ui == "story" and cur_level != 2 and cur_level != 5 and cur_level != 6 and cur_level != 8:
		ui_add("questions")
	if ui == "questions":
		question_closed.emit()

func ui_add(ui_name, param = null):
	get_tree().paused = true
	var ui = load("res://ui/" + ui_name + ".tscn").instantiate()
	ui.name = ui_name
	add_child(ui)
	if ui_name == "ui":
		ui.get_node("Menu").pressed.connect(ui_add.bind("menu"))
		ui.get_node("Timer").timeout.connect(timeout)
		ui_change.connect(ui.ui_change)
		ui_change.emit()
	elif ui_name == "menu":
		ui.get_node("VBoxContainer/Resume").pressed.connect(ui_remove.bind("menu"))
		ui.get_node("VBoxContainer/Restart").pressed.connect(restart)
		ui.get_node("VBoxContainer/MainMenu").pressed.connect(func(): get_tree().reload_current_scene())
	elif ui_name == "main_menu":
		ui.get_node("VBoxContainer/Button").pressed.connect(game_start)
		ui.get_node("VBoxContainer/Button2").pressed.connect(func(): mode = 1; game_start())
		ui.get_node("VBoxContainer/Button3").pressed.connect(ui_add.bind("login"))
		ui.get_node("VBoxContainer/Button4").pressed.connect(ui_add.bind("accounts"))
	elif ui_name == "story":
		ui.get_node("ColorRect/Button").pressed.connect(ui_remove.bind("story"))
	elif ui_name == "questions":
		ui.correct.connect(ui_remove.bind("questions"))
		ui.incorrect.connect(func(): wrong_answers += 1; ui_change.emit())
	elif ui_name == "death_message":
		ui.get_node("Label").display(param)
	elif ui_name == "game_end":
		ui.get_node("Button").pressed.connect(func(): get_tree().reload_current_scene())
	elif ui_name == "login":
		ui.success.connect(login)
	elif ui_name == "accounts":
		ui.get_node("Back").pressed.connect(ui_remove.bind("accounts"))

func save_game():
	var http_request = get_node("HTTPRequest")
	var data = {
		"username": username,
		"password": password,
		"deaths": deaths,
		"wrong_answers": wrong_answers
	}
	http_request.request("http://127.0.0.1:8000/api/add_game", ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(data))

func login(username1, password1):
	username = username1
	password = password1
	ui_remove("login")
	get_node("main_menu/Label").text = username
