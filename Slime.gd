extends KinematicBody2D

var moving = false
var player_position
var monster_position
var grid_size
var direction
var slime_speed = 36
var destination = Vector2()
var sprite
var continue_moving
var motion = Vector2()
var walking = false
var player
var type = 'slime'
var dead = false


func _ready():
	sprite = get_node("Sprite")

func _physics_process(delta):
	if !dead:
		if walking:
			walk()
		if moving and !walking and !player.falling:
			move_monster(delta)
			
func die():
	# Play dying animation
	dead = true
	queue_free()

func move_monster(delta):
	player_position = player.global_position
	gridify()
	if monster_position.y > player_position.y:
		direction = "up"
		motion.x = 0
		motion.y = -slime_speed*delta
		destination.x = global_position.x
		destination.y = global_position.y - grid_size
		walking = true
	elif monster_position.y < player_position.y:
		direction = "down"
		motion.x = 0
		motion.y = slime_speed*delta
		destination.x = global_position.x
		destination.y = global_position.y + grid_size
		walking = true
	elif monster_position.x > player_position.x:
		direction = "left"
		motion.x = -slime_speed*delta
		motion.y = 0
		destination.y = global_position.y
		destination.x = global_position.x - grid_size
		walking = true
	elif monster_position.x < player_position.x:
		direction = "right"
		motion.x = slime_speed*delta
		motion.y = 0
		destination.y = global_position.y
		destination.x = global_position.x + grid_size
		walking = true
	else:
		walking = false
		player.dead = true
		
	if monster_position.x > player_position.x:
		sprite.set_flip_h(true)
	if monster_position.x < player_position.x:
		sprite.set_flip_h(false)
	
func gridify():
	monster_position = global_position/grid_size
	monster_position.x = floor(monster_position.x) + 1
	monster_position.y = floor(monster_position.y) + 1
	player_position = player.global_position/grid_size
	player_position.x = floor(player_position.x) + 1
	player_position.y = floor(player_position.y) + 2		

func walk():
	if direction == "right" && global_position.x < destination.x:
		continue_moving = true
	elif direction == "left" && global_position.x > destination.x:
		continue_moving = true
	elif direction == "up" && global_position.y > destination.y:
		continue_moving = true
	elif direction == "down" && global_position.y < destination.y:
		continue_moving = true
	else:
		continue_moving = false
	
	if continue_moving:
		move_and_collide(motion)
	else:
		# Sets the position exactly to stop miscalculations due to delta
		global_position = destination
		walking = false
		moving = false
		var world = player.get_parent().get_parent()
		gridify()
		if player_position == monster_position && !player.falling:
			player.dead = true
		else:
			player.slimes_moved += 1
		if player.slime_moves == player.slimes_moved:
			player.monster_turn = false
