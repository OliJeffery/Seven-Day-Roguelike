extends Node2D

var player
var grid_size
var room
var player_position
var monster_position


func attack():	
	player = get_parent()
	grid_size = player.grid_size
	room = player.get_parent().get_parent()
	if player.direction == "left":
		$sword/AnimationPlayer.play("Swing sword (copy)")
	else:
		$sword/AnimationPlayer.play("Swing sword")
	var slimes = room.get_tree().get_nodes_in_group('slimes')
	player_position = player.global_position
	for slime in slimes:
		var slime_body = slime.get_node('slime_body')
		monster_position = slime_body.global_position
		gridify()
		if room.treasure == 0:
			if player_position.y == monster_position.y:
				if player.direction == "left":
					if player_position.x-1 == monster_position.x:
						slime.remove_from_group('slimes')
						slime_body.die()
				else:
					if player_position.x+1 == monster_position.x:
						slime.remove_from_group('slimes')	
						slime_body.die()
		if room.treasure == 1 or room.treasure == 2:
			if player_position.y == monster_position.y or player_position.y+1 == monster_position.y or player_position.y-1 == monster_position.y:
				if player.direction == "left":
					if player_position.x-1 == monster_position.x:
						slime.remove_from_group('slimes')
						slime_body.die()
				else:
					if player_position.x+1 == monster_position.x:
						slime.remove_from_group('slimes')	
						slime_body.die()

func gridify():
	monster_position = monster_position/grid_size
	monster_position.x = floor(monster_position.x) + 1
	monster_position.y = floor(monster_position.y) + 1
	player_position = player.global_position/grid_size
	player_position.x = floor(player_position.x) + 1
	player_position.y = floor(player_position.y) + 2
