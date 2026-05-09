extends Line2D

@onready var border = $border
@onready var fill = $fill
@onready var emb = $emb
var spine_pts = self.points


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	border.points = self.points
	fill.points = self.points.slice(1,-1)
	emb.points = self.points.slice(7,19)
