extends KinematicBody2D

var moving = false
var player_position
var grid_size
var direction

func _process(delta):
	if moving:
		move_monster()
		moving = false

func move_monster():
	var monster_position = global_position/16
	monster_position.x = floor(monster_position.x) + 1
	monster_position.y = floor(monster_position.y) + 1
	print(monster_position)
	 
