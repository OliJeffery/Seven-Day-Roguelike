extends Node2D

var width
var height
var monster_ratio
var number_of_monsters
var treasure_ratio
var treasure
var treasure_chance = 15
var room
var area
var rng = RandomNumberGenerator.new()
var slime = load("res://slime.tscn")
var door = load("res://door.tscn").instance()
var pit = load("res://pit.tscn").instance()
var chest = load("res://chest.tscn").instance()
var grid_size
var positions = {}

func _ready():
	rng.randomize()
	room = get_node("Floor")
	area = room.width * room.height
	number_of_monsters = floor(area * monster_ratio)
	treasure = floor(area * treasure_ratio)
	spawn_monsters()
	spawn_door()
	spawn_pit()
	if treasure > treasure_chance:
		spawn_treasure()
	else:
		print(treasure)
		
func spawn_monsters():
	for i in range(number_of_monsters):
		var slime_instance = slime.instance()
		var spawn = Vector2()
		spawn.x = (rng.randi_range(3,room.width)*grid_size)-(grid_size/2);
		spawn.y = (rng.randi_range(3,room.height)*grid_size)-(grid_size/2) - 2;
		slime_instance.global_position = spawn
		slime_instance.get_node('slime_body').grid_size = grid_size
		add_child(slime_instance)
		slime_instance.add_to_group('slimes')
		
func spawn_door():
	door.z_index = 2
	door.global_position = Vector2(room.width/2*grid_size, room.height*grid_size-2)
	add_child(door)
	
func spawn_treasure():
	print('SPAWNING TREASURE')
	var spawn = Vector2()
	spawn.x = (rng.randi_range(2,room.width-1)*grid_size)-(grid_size/2);
	spawn.y = (rng.randi_range(2,room.height-1)*grid_size)-(grid_size/2);
	positions['chest'] = spawn
	chest.global_position = spawn
	if positions['chest'] != positions['pit']:
		add_child(chest)

func spawn_pit():
	var spawn = Vector2()
	spawn.x = (rng.randi_range(2,room.width-1)*grid_size)-(grid_size/2);
	spawn.y = (rng.randi_range(2,room.height-1)*grid_size)-(grid_size/2);
	positions['pit'] = spawn
	pit.global_position = spawn
	add_child(pit)
