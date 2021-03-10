extends KinematicBody2D

var player_speed = 48
var grid_size = 16
var motion = Vector2()
var distance
var walking = false
var destination = Vector2()
var player 
var direction
var continue_moving = false

func _ready():
	player = get_node(".")

func _physics_process(delta):
	
	if !walking:
		
		$Sprite/AnimationPlayer.play("Idle")
	
		if Input.is_action_just_pressed("ui_right"):
			destination.x = player.position.x + grid_size
			destination.y = player.position.y
			motion.x = player_speed*delta
			motion.y = 0
			direction = "right"
			walking = true
		
		if Input.is_action_just_pressed("ui_left"):
			destination.x = player.position.x - grid_size
			destination.y = player.position.y
			motion.x = -player_speed*delta
			motion.y = 0
			direction = "left"
			walking = true
			
		if Input.is_action_just_pressed("ui_down"):
			destination.y = player.position.y + grid_size
			destination.x = player.position.x
			motion.x = 0
			motion.y = player_speed*delta
			direction = "down"
			walking = true
			
		if Input.is_action_just_pressed("ui_up"):
			destination.y = player.position.y - grid_size
			destination.x = player.position.x
			motion.x = 0
			motion.y = -player_speed*delta
			direction = "up"
			walking = true
			
	if walking:
		walk()
		

func walk():
	$Sprite/AnimationPlayer.play("Walking")
	if direction == "right" && player.position.x < destination.x:
		continue_moving = true
	elif direction == "left" && player.position.x > destination.x:
		continue_moving = true
	elif direction == "up" && player.position.y > destination.y:
		continue_moving = true
	elif direction == "down" && player.position.y < destination.y:
		continue_moving = true
	else:
		continue_moving = false
	
	if continue_moving:
		move_and_collide(motion)
	else:
		player.position = destination
		walking = false	
	
