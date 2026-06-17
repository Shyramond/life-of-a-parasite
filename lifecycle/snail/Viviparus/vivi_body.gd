extends "res://snail/dec_proc.gd"

func _process(delta):
	var pts = self.points
	shell.position = pts[13]
	shell.rotation = (pts[14] - pts[12]).angle()
	
	t_l.points = [pts[6], pts[6] + (pts[6] - pts[7]).rotated(PI/4.2) * 15]
	t_r.points = [pts[6], pts[6] + (pts[6] - pts[7]).rotated(-PI/4.2) * 15]
