extends Node

signal death_signal(reason)
signal level_complete_signal

const level_time = [70, 40, 60, 30, 30, 40, 60]

var deaths = 0
var cur_level = 2

func _ready() -> void:
	main_menu()

func _process(delta: float) -> void:
	pass

func level_load():
	var level = load("res://level1/stage" + str(cur_level) + "/main.tscn").instantiate()
	level.name = "Level"
	call_deferred("add_child", level)
	call_deferred("move_child", level, 0)
	level.get_node("Player").death.connect(death)
	level.get_node("Player").level_complete.connect(level_complete)
	get_tree().paused = false

func main_menu():
	var menu = preload("res://ui/main_menu.tscn").instantiate()
	menu.name = "MainMenu"
	add_child(menu)
	menu.get_node("VBoxContainer/NewGame").pressed.connect(game_load)

func ui():
	var ui = preload("res://ui/ui.tscn").instantiate()
	ui.name = "UI"
	add_child(ui)
	ui.get_node("Menu").pressed.connect(menu)
	ui.get_node("Deaths").text = "Смерти: " + str(deaths)
	ui.get_node("Timer").wait_time = level_time[cur_level - 1]
	ui.get_node("Timer").timeout.connect(timeout)
	ui.get_node("Timer").start()

func menu() -> void:
	get_tree().paused = true
	var menu = preload("res://ui/menu.tscn").instantiate()
	menu.name = "Menu"
	add_child(menu)
	menu.get_node("VBoxContainer/Resume").pressed.connect(resume)
	menu.get_node("VBoxContainer/Restart").pressed.connect(restart)
	menu.get_node("VBoxContainer/MainMenu").pressed.connect(main_menu_button)

func resume():
	get_node("Menu").queue_free()
	get_tree().paused = false

func restart():
	deaths += 1
	game_load()

func main_menu_button():
	get_tree().reload_current_scene()

func death(reason):
	death_signal.emit(reason)
	get_tree().paused = true
	await get_tree().create_timer(3.0).timeout
	get_tree().paused = false
	deaths += 1
	game_load()

func game_load():
	for i in get_children():
		i.queue_free()
	level_load()
	ui()

func level_complete():
	level_complete_signal.emit()
	get_tree().paused = true
	if cur_level != 7:
		await get_tree().create_timer(1.0).timeout
		cur_level += 1
		game_load()

func timeout():
	if cur_level == 3 or cur_level == 7:
		level_complete()
	else:
		death("timeout")
