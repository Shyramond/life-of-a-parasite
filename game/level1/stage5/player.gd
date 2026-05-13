extends Node

signal death(reason)
signal level_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_2_death(reason: Variant) -> void:
	death.emit(reason)


func _on_area_2d_2_level_complete() -> void:
	level_complete.emit()
