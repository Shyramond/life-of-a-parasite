extends Camera2D

var zoom_speed = Vector2(0.1, 0.1)
var min_zoom = Vector2(0.5, 0.5)
var max_zoom = Vector2(3, 3)

func _unhandled_input(event):
	if event.is_action_pressed("zoom_out"):
		zoom -= zoom_speed
	if event.is_action_pressed("zoom_in"):
		zoom += zoom_speed
	zoom = zoom.clamp(min_zoom, max_zoom)
