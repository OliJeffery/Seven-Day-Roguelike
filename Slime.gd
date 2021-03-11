extends KinematicBody2D

var moving = false
var player_position
var monster_position
var grid_size
var direction

func _process(delta):
	if moving:
		move_monster()
		moving = false

func move_monster():
	gridify()
	if monster_position.y > player_position.y:
		print('MOVING UP')
	elif monster_position.y < player_position.y:
		print('MOVING DOWN')
	elif monster_position.x > player_position.x:
		print('MOVING LEFT')
	elif monster_position.x > player_position.x:
		print('MOVING RIGHT')
	else:
		print('NOM')
	
func gridify():
	monster_position = global_position/grid_size
	monster_position.x = floor(monster_position.x) + 1
	monster_position.y = floor(monster_position.y) + 1
	player_position = player_position/grid_size
	player_position.x = floor(player_position.x) + 1
	player_position.y = floor(player_position.y) + 2

	 
