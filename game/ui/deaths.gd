extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/Node").death.connect(death)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func death():
	text = str(int(text) + 1)
