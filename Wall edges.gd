extends TileMap

var room 
var grid_size 

func _ready():
	room = get_parent().get_node("Floor")
	print(room.width)
	print(room.height)
	grid_size = get_parent().grid_size
	# Top edges
	for x in range(room.width-2):
		set_cell(x+1, -1, 2, false, true)
		set_cell(x+1, room.height-1, 2)
	# Side edges
	for y in range(room.height-1):
		set_cell(0, y, 1)
		set_cell(room.width-1, y, 1, true)
	# Top left corner
	set_cell(0, -1, 3)
	# Bottom leftt corner
	set_cell(0, room.height-1, 3, false, true)
	# Top right corner
	set_cell(room.width-1, -1, 3, true, false)
	# Bottom right corner
	set_cell(room.width-1, room.height-1, 3, true, true)
