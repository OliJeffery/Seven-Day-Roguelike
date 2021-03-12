extends KinematicBody2D

var moving = false
var player_position
var monster_position
var grid_size
var direction
var slime_speed = 10
var destination = Vector2()
var sprite
var continue_moving
var motion = Vector2()
var walking = false

func _ready():
	sprite = get_node("Sprite")

func _physics_process(delta):
	if walking:
		walk()
	if moving and !walking:
		move_monster(delta)

func move_monster(delta):
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
	
func gridify():
	monster_position = global_position/grid_size
	monster_position.x = floor(monster_position.x) + 1
	monster_position.y = floor(monster_position.y) + 1
	player_position = player_position/grid_size
	player_position.x = floor(player_position.x) + 1
	player_position.y = floor(player_position.y) + 2		

func walk():
	if direction == "right" && global_position.x < destination.x:
		sprite.set_flip_h(false)
		continue_moving = true
	elif direction == "left" && global_position.x > destination.x:
		sprite.set_flip_h(true)
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
