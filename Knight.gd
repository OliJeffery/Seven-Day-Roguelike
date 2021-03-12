extends KinematicBody2D

var player_speed = 48
var grid_size
var motion = Vector2()
var distance
var walking = false
var destination = Vector2()
var player 
var direction
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

func _ready():
	player = get_node(".")
	player.global_position = initial_position
	sprite = player.get_node("Sprite")
	add_child(weapon)
	weapon.z_index=0

func _physics_process(delta):
	
	if dead:
		remove_child(weapon)
	
	if !walking && !falling && !monster_turn && !dead && !scene_loading:
		
		$Sprite/AnimationPlayer.play("Idle")
		
		if Input.is_action_just_pressed("ui_accept"):
			weapon.attack()
			player_turn_over()
	
		if Input.is_action_just_pressed("ui_right"):
			destination.x = player.global_position.x + grid_size
			destination.y = player.global_position.y
			motion.x = player_speed*delta
			motion.y = 0
			direction = "right"
			if destination.x > room_area.x:
				return
			walking = true
		
		if Input.is_action_just_pressed("ui_left"):
			destination.x = player.global_position.x - grid_size
			destination.y = player.global_position.y
			motion.x = -player_speed*delta
			motion.y = 0
			direction = "left"
			if destination.x < 0:
				return
			walking = true
			
		if Input.is_action_just_pressed("ui_down"):
			destination.y = player.global_position.y + grid_size
			destination.x = player.global_position.x
			motion.x = 0
			motion.y = player_speed*delta
			direction = "down"
			if destination.y >= room_area.y - grid_size:
				return
			walking = true
			
		if Input.is_action_just_pressed("ui_up"):
			destination.y = player.global_position.y - grid_size
			destination.x = player.global_position.x
			motion.x = 0
			motion.y = -player_speed*delta
			direction = "up"
			if destination.y <= - grid_size:
				return
			walking = true
			
	if walking:
		walk()

func update_weapon():
	add_child(weapon)

func walk():
	$Sprite/AnimationPlayer.play("Walking")
	if direction == "right" && player.global_position.x < destination.x:
		sprite.set_flip_h(false)
		continue_moving = true
	elif direction == "left" && player.global_position.x > destination.x:
		sprite.set_flip_h(true)
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
