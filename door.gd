extends StaticBody2D

var rattling = false
var rattled = 0
var coords = [2, -4, 2]

func _process(delta):
	if rattling:
		rattle_door()

func rattle_door():
	global_position.y += coords[rattled]
	rattled +=1
	if rattled == 3:
		rattling = false	
