extends KinematicBody2D

var player_speed = 48
var grid_size
var motion = Vector2()
var distance
var walking = false
var destination = Vector2()
var player 
var direction = "right"
var continue_moving = false
var room_area = Vector2()
var initial_position = Vector2()
var sprite
var final_position = Vector2()
var falling = false
var monster_turn = false
var player_turns = 2
var current_turn = 0
var weapon 
var dead = false
var scene_loading
var has_key = false
var player_position
var monster_position
var play_death_sound = true

func _ready():
	player = get_node(".")
	player.global_position = initial_position
	sprite = player.get_node("Sprite")
	add_child(weapon)
	weapon.z_index=0

func _physics_process(delta):
	
	if dead:
		if play_death_sound:
			remove_child(weapon)
			$die.play()
			play_death_sound = false
	
	if !walking && !falling && !monster_turn && !dead && !scene_loading:
		
		$Sprite/AnimationPlayer.play("Idle")
		
		if Input.is_action_just_pressed("ui_accept"):
			if player_can_attack():
				weapon.attack()
				$slash.play()
				player_turn_over()
			print('No mobs nearby')
	
		if Input.is_action_just_pressed("ui_right"):
			destination.x = player.global_position.x + grid_size
			destination.y = player.global_position.y
			motion.x = player_speed*delta
			motion.y = 0
			direction = "right"
			if destination.x > room_area.x:
				return
			$walk.play(0)
			walking = true
		
		if Input.is_action_just_pressed("ui_left"):
			destination.x = player.global_position.x - grid_size
			destination.y = player.global_position.y
			motion.x = -player_speed*delta
			motion.y = 0
			direction = "left"
			if destination.x < 0:
				return
			$walk.play(0)
			walking = true
			
		if Input.is_action_just_pressed("ui_down"):
			destination.y = player.global_position.y + grid_size
			destination.x = player.global_position.x
			motion.x = 0
			motion.y = player_speed*delta
			direction = "down"
			if destination.y >= room_area.y - grid_size:
				return
			$walk.play(0)
			walking = true
			
		if Input.is_action_just_pressed("ui_up"):
			destination.y = player.global_position.y - grid_size
			destination.x = player.global_position.x
			motion.x = 0
			motion.y = -player_speed*delta
			direction = "up"
			if destination.y <= - grid_size:
				return
			$walk.play(0)
			walking = true
			
	if walking:
		walk()

func update_weapon():
	add_child(weapon)

func walk():
	$Sprite/AnimationPlayer.play("Walking")
	if direction == "right" && player.global_position.x < destination.x:
		sprite.set_flip_h(false)
		weapon.get_node('sword').get_node('Sprite').set_flip_h(false)
		weapon.position.x = 0
		continue_moving = true
	elif direction == "left" && player.global_position.x > destination.x:
		sprite.set_flip_h(true)
		weapon.get_node('sword').get_node('Sprite').set_flip_h(true)
		weapon.position.x = -grid_size
		continue_moving = true
	elif direction == "up" && player.global_position.y > destination.y:
		continue_moving = true
	elif direction == "down" && player.global_position.y < destination.y:
		continue_moving = true
	else:
		continue_moving = false
	
	if continue_moving:
		move_and_collide(motion)
	else:
		# Sets the position exactly to stop miscalculations due to delta
		player.global_position = destination		
		walking = false	
		final_position.x = ceil(player.global_position.x)
		final_position.y = player.global_position.y + 9
		player_turn_over()
		
func player_turn_over():
	current_turn += 1
	if current_turn == player_turns && !falling:
		current_turn = 0
		monster_turn = true
		var room = get_parent().get_parent()
		var slimes = room.get_tree().get_nodes_in_group('slimes')
		if slimes != []:
			$slime_move.play()

func player_can_attack():
	var room = get_parent().get_parent()
	var slimes = room.get_tree().get_nodes_in_group('slimes')
	player_position = global_position
	for slime in slimes:
		var slime_body = slime.get_node('slime_body')
		monster_position = slime_body.global_position
		gridify()
		if room.treasure == 0:
			if player_position.y == monster_position.y:
				if player_position.x-1 == monster_position.x or player_position.x+1 == monster_position.x:
					return true
		if room.treasure == 1 or room.treasure == 2:
			if player_position.y == monster_position.y or player_position.y+1 == monster_position.y or player_position.y-1 == monster_position.y:
				if player_position.x-1 == monster_position.x or player_position.x+1 == monster_position.x:
					return true
	return false

func gridify():
	monster_position = monster_position/grid_size
	monster_position.x = floor(monster_position.x) + 1
	monster_position.y = floor(monster_position.y) + 1
	player_position = player.global_position/grid_size
	player_position.x = floor(player_position.x) + 1
	player_position.y = floor(player_position.y) + 2
