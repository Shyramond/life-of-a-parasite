extends Node

signal death_signal(reason)
signal level_complete_signal

var deaths = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func level1():
	var level1 = preload("res://level1/main.tscn").instantiate()
	level1.name = "Level1"
	call_deferred("add_child", level1)
	call_deferred("move_child", level1, 0)
	level1.get_node("Of-egg").death.connect(death)
	level1.get_node("Of-egg").level_complete.connect(level_complete)
	get_tree().paused = false

func main_menu():
	var menu = preload("res://ui/main_menu.tscn").instantiate()
	menu.name = "MainMenu"
	add_child(menu)
	menu.get_node("VBoxContainer/NewGame").pressed.connect(new_game)

func ui():
	var ui = preload("res://ui/ui.tscn").instantiate()
	ui.name = "UI"
	add_child(ui)
	ui.get_node("Menu").pressed.connect(menu)
	ui.get_node("Timer").timeout.connect(death.bind("timeout"))
	ui.get_node("Deaths").text = "Смерти: " + str(deaths)

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
	for i in get_children():
		i.queue_free()
	level1()
	ui()

func main_menu_button():
	get_tree().reload_current_scene()

func new_game():
	get_node("MainMenu").queue_free()
	level1()
	ui()

func death(reason):
	death_signal.emit(reason)
	get_tree().paused = true
	await get_tree().create_timer(3.0).timeout
	get_tree().paused = false
	restart()

func level_complete():
	level_complete_signal.emit()
	get_tree().paused = true
