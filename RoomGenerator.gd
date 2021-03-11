extends Node2D

var width
var height
var monster_ratio = .1
var number_of_monsters
var room
var area
var rng = RandomNumberGenerator.new()
var slime = load("res://slime.tscn")
var grid_size

func _ready():
	rng.randomize()
	room = get_node("Floor")
	area = room.width * room.height
	number_of_monsters = floor(area * monster_ratio)
	spawn_monsters()
	
func spawn_monsters():
	for i in range(number_of_monsters):
		var spawn = Vector2()
		spawn.x = (rng.randi_range(1,room.width)*grid_size)-(grid_size/2);
		spawn.y = (rng.randi_range(1,room.height)*grid_size)-(grid_size/2) - 2;
		
		print("Spawning monster")
		print(spawn)
		var slime_instance = slime.instance()
		slime_instance.global_position = spawn
		add_child(slime_instance)

