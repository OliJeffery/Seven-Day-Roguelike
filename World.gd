extends Node2D

var room = load("res://RoomGenerator.tscn")
var player = load("res://player_knight.tscn").instance()
var grid_size = 16

func _ready():
	
	var starting_room = room.instance()
	starting_room.set_name("starting_room")
	starting_room.grid_size = grid_size
	#starting_room.width=6
	#starting_room.height=6
	add_child(starting_room)
	
	var tilemap = starting_room.get_node('Floor')
	var room_height = tilemap.height * grid_size
	var room_width = tilemap.width * grid_size
	var room_area = Vector2(room_width, room_height)
	
	
	var player_body = player.get_node('Player')
	player_body.grid_size = grid_size
	player_body.room_area = room_area
	player_body.initial_position = Vector2(7.5,-1)
	add_child(player)
	
	
	
	
	
	

