extends "res://level1/snail/dec_proc.gd"

func _process(delta):
	var pts = self.points
	shell.position = pts[13]
	shell.rotation = (pts[14] - pts[12]).angle()
	
	t_l.points = [pts[2], pts[2] + (pts[2] - pts[3]).rotated(PI/4.2) * 12]
	t_r.points = [pts[2], pts[2] + (pts[2] - pts[3]).rotated(-PI/4.2) * 12]
