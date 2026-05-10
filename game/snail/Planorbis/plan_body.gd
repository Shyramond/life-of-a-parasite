extends "res://snail/dec_proc.gd"

func _process(delta):
	var pts = self.points
	shell.position = pts[13]
	shell.rotation = (pts[14] - pts[12]).angle()
	
	t_l.points = [pts[3], pts[3] + (pts[3] - pts[4]).rotated(PI/3) * 15]
	t_r.points = [pts[3], pts[3] + (pts[3] - pts[4]).rotated(-PI/3) * 15]
