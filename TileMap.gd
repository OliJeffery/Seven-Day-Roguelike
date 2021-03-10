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
			set_cell(x, y, tile())

func tile():
	var rand = rng.randi_range(1, 100)
	if odd_tiles < max_odd_tiles:
		if rand == 1:
			odd_tiles+=1
			return 3
		if rand < 10:
			odd_tiles+=1
			return 1
		if rand < 20:
			odd_tiles+=1
			return 2
	return 0

func get_room_size():
	width = rng.randi_range(2, 10)
	height = rng.randi_range(2,10)
