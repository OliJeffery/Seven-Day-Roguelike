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
var monster_ratio = 0
var treasure_ratio = 1
var weapon = load("res://sword_rusty.tscn")
var game_over = false
var level = 0
var chest_open = false

func _ready():
	print('NEW GAME')
	new_room()	

func _process(delta):
	if !game_over:
		if player_body.dead:
			game_over()
		if !player_body.falling:
			check_for_pit()
			if !chest_open:
				chest_open = check_for_treasure()	
			if oubliette.global_position.y > 0:
				player_body.scene_loading = true
				oubliette.global_position.y -= gravity*delta
			else:
				player_body.scene_loading = false
				player.z_index = 0	
			if monster_turn:
				print('monster_turn')
				var slimes = oubliette.get_tree().get_nodes_in_group('slimes')
				for slime in slimes:
					var slime_body = slime.get_node('slime_body')
					slime_body.moving = true
					slime_body.player = player_body
				player_body.monster_turn = false
	else:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
			
func pit_goes_nom():
	player.hide()
	player_body.falling = true
	var pit = oubliette.pit.get_node("Pit")
	pit.get_node("AnimationPlayer").play("Falling")
	yield(pit.get_node("AnimationPlayer"), "animation_finished")
	new_room()
	
func check_for_pit():
	monster_turn = player_body.monster_turn
	if player_body.final_position == oubliette.positions['pit']:
		pit_goes_nom()

func check_for_treasure():
	var open_treasure = false
	var player_position = player_body.final_position
	var chest_position = oubliette.positions['chest']
	if	player_position.y == chest_position.y:
		if player_position.x == chest_position.x + grid_size or player_position.x == chest_position.x - grid_size:
			open_treasure = true
	elif	player_position.x == chest_position.x:
		if player_position.y == chest_position.y + grid_size or player_position.y == chest_position.y - grid_size:
			open_treasure = true
	if open_treasure:
		oubliette.chest.open()
	return open_treasure	
			
func new_room():
	level +=1
	print("LEVEL ", level)
	if oubliette:
		destroy_room()
	chest_open = false
	oubliette = generator.instance()
	oubliette.monster_ratio = monster_ratio
	oubliette.treasure_ratio = treasure_ratio
	monster_ratio+=.015
	treasure_ratio+=.1
	#oubliette.width = 6
	#oubliette.height = 6
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
	player_body.weapon = weapon.instance()
	player_body.grid_size = grid_size
	player_body.room_area = room_area
	player_body.initial_position = Vector2(7.5,-1)
	player_body.get_node('game_over').hide()
	add_child(player)	
	
func destroy_room():
	oubliette.queue_free()
	player.queue_free()
	
func game_over():
	game_over = true
	player_body.get_node('Sprite').hide()
	player_body.weapon = null
	var game_over_sign = player_body.get_node('game_over')
	player_body.z_index = 10
	game_over_sign.show()
	print('GAME OVER')
