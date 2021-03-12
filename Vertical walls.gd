extends TileMap

var room 
var grid_size 

func _ready():
	room = get_parent().get_node("Floor")
	grid_size = get_parent().grid_size
	for x in range(room.width):
		set_cell(x, -1, 1)
		set_cell(x, room.height, 1)
