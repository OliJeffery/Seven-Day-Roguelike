extends TileMap

var room 
var grid_size 

func _ready():
	room = get_parent().get_node("Floor")
	print(room.width)
	print(room.height)
	grid_size = get_parent().grid_size
	for x in range(room.width-2):
		set_cell(x+1, -2, 2)
		set_cell(x+1, room.height-1, 2)
	for y in range(room.height-1):
		set_cell(0, y, 1)
		set_cell(room.width-1, y, 1, true)

