extends "res://level1/snail/dec_proc.gd"


func _process(delta):
	var pts = self.points
	shell.position = pts[12]
	shell.rotation = (pts[14] - pts[10]).angle()
	
	t_l.points = [pts[3], pts[3] + (pts[3] - pts[4]).rotated(PI/5) * 10]
	t_r.points = [pts[3], pts[3] + (pts[3] - pts[4]).rotated(-PI/5) * 10]
	
