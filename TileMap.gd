extends TileMap

var height
var width
var shape
var rng = RandomNumberGenerator.new()
var recent
var odd_tiles
var max_odd_tiles

func _ready():
	rng.randomize()
	get_room_size()
	odd_tiles = 0
	max_odd_tiles = (width*height)*.1
	for x in range(width):
		for y in range(height):
			set_cell(x, y, random_tile())

func random_tile():
	var rand = rng.randi_range(1, 100)
	if odd_tiles < max_odd_tiles:
		if rand < 5:
			odd_tiles+=1
			return 1
		if rand < 10:
			odd_tiles+=1
			return 2
		if rand < 15:
			odd_tiles+=1
			return 3
		if rand < 20:
			odd_tiles+=1
			return 4
		if rand < 25:
			odd_tiles+=1
			return 5
		if rand < 30:
			odd_tiles+=1
			return 6
	return 0

func get_room_size():
	var parent = get_parent()
	if parent.width != null:
		width = parent.width
	else:
		width = rng.randi_range(2, 10)
	if parent.height != null:
		height = parent.height
	else:
		height = rng.randi_range(2,10)
