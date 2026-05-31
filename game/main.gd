extends Node

signal death_signal(reason)
signal level_complete_signal

const level_time = [70, 40, 60, 30, 30, 20, 40, 60]

var deaths = 0
var cur_level = 1

func _ready() -> void:
	main_menu()

func _process(delta: float) -> void:
	pass

func signal_connect(level):
	if cur_level == 3:
		level.get_node("Player").death.connect(death)
		level.get_node("Player2").death.connect(death)
		level.get_node("Player3").death.connect(death)
	elif cur_level == 5:
		level.get_node("Path2D/PathFollow2D/Area2D2").death.connect(death)
		level.get_node("Path2D/PathFollow2D/Area2D2").level_complete.connect(level_complete)
	elif cur_level == 6:
		level.death.connect(death)
		level.level_complete.connect(level_complete)
	elif cur_level == 8:
		level.get_node("Player").death.connect(death)
	else:
		level.get_node("Player").death.connect(death)
		level.get_node("Player").level_complete.connect(level_complete)

func level_load():
	var level = load("res://level1/stage" + str(cur_level) + "/main.tscn").instantiate()
	level.name = "Level"
	call_deferred("add_child", level)
	call_deferred("move_child", level, 0)
	signal_connect(level)
	get_tree().paused = false
	get_node("UI/Timer").wait_time = level_time[cur_level - 1]
	get_node("UI/Timer").start()

func main_menu():
	var menu = preload("res://ui/main_menu.tscn").instantiate()
	menu.name = "MainMenu"
	add_child(menu)
	menu.get_node("VBoxContainer/NewGame").pressed.connect(game_start)

func ui():
	var ui = preload("res://ui/ui.tscn").instantiate()
	ui.name = "UI"
	add_child(ui)
	ui.get_node("Menu").pressed.connect(menu)
	ui.get_node("Deaths").text = "Смерти: " + str(deaths)
	ui.get_node("Timer").timeout.connect(timeout)

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
		i.name = str(i)
		i.queue_free()
	ui()
	level_load()

func level_complete():
	level_complete_signal.emit()
	get_tree().paused = true
	get_node("Level").name = "Level2"
	get_node("Level2").queue_free()
	if cur_level != 8:
		cur_level += 1
	level_load()
	story_add()

func timeout():
	print("gsegse")
	if cur_level == 3 or cur_level == 8:
		level_complete()
	else:
		death("timeout" + str(cur_level))

func story_remove():
	get_node("Story").queue_free()
	get_tree().paused = false

func story_add():
	get_tree().paused = true
	var story = preload("res://ui/story.tscn").instantiate()
	story.name = "Story"
	add_child(story)
	get_node("Story/ColorRect/Button").pressed.connect(story_remove)

func game_start():
	game_load()
	get_tree().paused = true
	story_add()
