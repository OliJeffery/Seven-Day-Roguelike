extends Node2D

var oubliette
var generator = load("res://RoomGenerator.tscn") 
var player_mould = load("res://player_knight.tscn")
var grid_size = 16
var player_body
var player
var fall_distance = 6
var gravity = 100
var monster_turn

func _ready():
	new_room()

func _process(delta):
	if !player_body.falling:
		monster_turn = player_body.monster_turn
		if player_body.final_position == oubliette.positions['pit']:
			pit_goes_nom()
		if oubliette.global_position.y > 0:
			oubliette.global_position.y -= gravity*delta
		else:
			player.z_index = 0	
		if monster_turn:
			print('monster_turn')
			player_body.monster_turn = false
			
func pit_goes_nom():
	player.hide()
	player_body.falling = true
	var pit = oubliette.pit.get_node("Pit")
	pit.get_node("AnimationPlayer").play("Falling")
	yield(pit.get_node("AnimationPlayer"), "animation_finished")
	new_room()	
	
func new_room():
	if oubliette:
		destroy_room()
	oubliette = generator.instance()
	oubliette.set_name("oubliette")
	oubliette.grid_size = grid_size
	oubliette.global_position = Vector2(0, fall_distance*grid_size)
	
	add_child(oubliette)
	var tilemap = oubliette.get_node('Floor')
	var room_height = tilemap.height * grid_size
	var room_width = tilemap.width * grid_size
	var room_area = Vector2(room_width, room_height)	
	player = player_mould.instance()
	player.z_index = 3
	player_body = player.get_node('Player')
	player_body.grid_size = grid_size
	player_body.room_area = room_area
	player_body.initial_position = Vector2(7.5,-1)
	add_child(player)	
	
func destroy_room():
	oubliette.queue_free()
	player.queue_free()
