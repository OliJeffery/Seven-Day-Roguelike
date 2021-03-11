extends Node2D

var oubliette = load("res://RoomGenerator.tscn").instance()
var player = load("res://player_knight.tscn").instance()
var grid_size = 16
var player_body

func _ready():
	
	oubliette.set_name("starting_room")
	oubliette.grid_size = grid_size
	#oubliette.width=6
	#oubliette.height=6
	add_child(oubliette)
	
	var tilemap = oubliette.get_node('Floor')
	var room_height = tilemap.height * grid_size
	var room_width = tilemap.width * grid_size
	var room_area = Vector2(room_width, room_height)
	
	
	player_body = player.get_node('Player')
	player_body.grid_size = grid_size
	player_body.room_area = room_area
	player_body.initial_position = Vector2(7.5,-1)
	add_child(player)

func _process(delta):
	if !player_body.falling:
		if player_body.final_position == oubliette.positions['pit']:
			player.hide()
			player_body.falling = true
			var pit = oubliette.pit.get_node("Pit")
			pit.get_node("AnimationPlayer").play("Falling")
			
			
	
	
	
	

