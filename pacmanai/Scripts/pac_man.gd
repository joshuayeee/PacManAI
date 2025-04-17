#Author: Joshua Yee
#Date Last Edited: April 16, 2025
#Purpose: Defines Pac-Man's controls

#gets methods and vars from CharacterBody2D
extends CharacterBody2D

#speed of pac-man
const SPEED = 300.0
#the point where pac-man goes to the other side of the map
const FLIP_POINT = 592

#reference to the animated sprite that represents pac-man graphically
@onready var animated_sprite_2d = $AnimatedSprite2D

#determines if pac-man can go right
var right_way = false
#determines if pac-man can go left
var left_way = false
#determines if pac-man can go up
var up_way = false
#determines if pac-man can go down
var down_way = false

#determines what direction pac-man is goin in
var curr_dir = "right"

#determines if pac-man can move or not
var can_move = true

#determines if pac-man is moving along a horizontal axis
var is_hori = true

#holds the current turn point that pac-man is on
var curr_point = null

#check if pac-man is in its super mode
var is_super = false

#the timer that determines how long super mode lasts for
@onready var super_timer = $SuperTimer

#function that runs every frame (optimized for physics)
func _physics_process(_delta):
	#checks if pac-man is moving along the horizontal axis or not
	if (is_hori):
		#SIDENOTE: GO TO PROJECT > PROJECT SETTINGS > INPUT MAP TO LOOK AT THE ACTIONS THE USER CAN USE
		
		#check if the player used the "right" action (D)
		if (Input.is_action_pressed("right")):
			#set pac-man's current direction to right
			curr_dir = "right"
			#update pac-man's animation
			update_animation()
		#check if the player used the "left" action (A)
		elif (Input.is_action_pressed("left")):
			#set pac-man's current direction to left
			curr_dir = "left"
			#update pac-man's animation
			update_animation()
		
		#check if the player used the "up" action (W)
		#also check if pac-man can move up
		if (Input.is_action_pressed("up") and up_way):
			#set pac-man's current direction to up
			curr_dir = "up"
			#update pac-man's animation
			update_animation()
			#adjust pac-man's position
			adjust_position()
			#pac-man is no longer on the horizontal axis
			#set is hori to false
			is_hori = false
		
		#checks if the player used the "down" action (S)
		#also check if pac-man can move down
		if (Input.is_action_pressed("down") and down_way):
			#set pac-man's current direction to down
			curr_dir = "down"
			#update pac-man's animation
			update_animation()
			#adjust pac-man's position
			adjust_position()
			#pac-man is no longer on the horizontal axis
			#set is hori to false
			is_hori = false
			
	else:
		#check if the player used the "up" action (W)
		if (Input.is_action_pressed("up")):
			#set pac-man's current direction to up
			curr_dir = "up"
			#update pac-man's animation
			update_animation()
		#check if the player used the "down" action (S)
		elif (Input.is_action_pressed("down")):
			#set pac-man's current direction to down
			curr_dir = "down"
			#update pac-man's animation
			update_animation()
		
		#check if the player used the "right" action (A)
		#also check if pac-man can move right
		if (Input.is_action_pressed("right") and right_way):
			#set pac-man's current direction to right
			curr_dir = "right"
			#udpate pac-man's animation
			update_animation()
			#adjust pac-man's position
			adjust_position()
			#pac-man is now on the horizontal axis
			#set is hori to true
			is_hori = true
		
		#check if the player used the "left" action (A)
		#also check if pac-man can move left
		if (Input.is_action_pressed("left") and left_way):
			#set pac-man's current direction to left
			curr_dir = "left"
			#update pac-man's animation
			update_animation()
			#adjust pac-man's position
			adjust_position()
			#pac-man is now on the horizontal axis
			#set is hori to true
			is_hori = true
	
	#check if pac-man is in its super mode
	#also check if the super timer hasn't started already
	if (is_super and super_timer.is_stopped()):
		#start the super timer
		super_timer.start()
		print("super")
	
	#check if pac-man can move
	if (can_move):
		#check if pac-man's current direction is right
		if (curr_dir == "right"):
			#set pac-man's x velocity to SPEED
			velocity.x = SPEED
			#set pac-man's y velocity to 0
			velocity.y = 0
		#check if pac-man's current direction is left
		elif (curr_dir == "left"):
			#set pac-man's x velocity to -SPEED
			velocity.x = -SPEED
			#set pac-man's y velocity to 0
			velocity.y = 0
		#check if pac-man's current direction is up
		elif (curr_dir == "up"):
			#set pac-man's y velocity to -SPEED
			velocity.y = -SPEED
			#set pac-man's x velocity to 0
			velocity.x = 0
		#check if pac-man's current direction is down
		elif (curr_dir == "down"):
			#set pac-man's y velocity to SPEED
			velocity.y = SPEED
			#set pac-man's x velocity to 0
			velocity.x = 0
		
		#function from CharacterBody2D that handles movement
		move_and_slide()
	else:
		#pauses pac-man's animated sprite
		animated_sprite_2d.pause()
		
		#checks pac-man's current direction
		#checks if pac-man can move in its current direction
		if (curr_dir == "right" and (right_way)
		|| curr_dir == "left" and (left_way)
		|| curr_dir == "up" and (up_way)
		|| curr_dir == "down" and (down_way)):
			#pac-man can move
			can_move = true
	
	#HANDLES SCREEN WRAPPING
	#check if pac-man's x position is greater than FLIP_POINT
	if (position.x > FLIP_POINT):
		#set pac-man's x position to -FLIP_POINT
		position.x = -FLIP_POINT
	#check if pac-man's x position is less than -FLIP_POINT
	elif (position.x < -FLIP_POINT):
		#set pac-man's x position to FLIP_POINT
		position.x = FLIP_POINT

#adjust pac-man's position so that it perfectly aligns with the turn point it is on
func adjust_position():
	#check if pac-man is on a turn point
	if (curr_point != null):
		#set pac-man's position to be the current turn point's position
		position = curr_point.position

#updates pac-man's animation depending on its current direction
func update_animation():
	#check if pac-man's current direction is right
	if (curr_dir == "right"):
		#make pac-man's animated sprite play "right_move" animation
		animated_sprite_2d.play("right_move")
	#check if pac-man's current direction is left
	elif (curr_dir == "left"):
		#make pac-man's animated sprite play "left_move" animation
		animated_sprite_2d.play("left_move")
	#check if pac-man's current direction is up
	elif (curr_dir == "up"):
		#make pac-man's animated sprite play "up_move" animation
		animated_sprite_2d.play("up_move")
	#check if pac-man's current direction is down
	elif (curr_dir == "down"):
		#make pac-man's animated sprite play "down_move" animation
		animated_sprite_2d.play("down_move")

#checks if pac-man is at a turn point (var body is the turn point)
func _on_turn_point_check_body_entered(body):
	#set the current turn point to be the turn point pac-man is currently on
	curr_point = body
	
	#get the bool that checks if pac-man can go right from this turn point
	right_way = body.right_way
	#get the bool that checks if pac-man can go left from this turn point
	left_way = body.left_way
	#get the bool that checks if pac-man can go up from this turn point
	up_way = body.up_way
	#get the bool that checks if pac-man can go down form this turn point
	down_way = body.down_way
	
	#check if pac-man's current direction does not align with the allowed directions given from the turn point
	if (curr_dir == "right" and (not right_way)
		|| curr_dir == "left" and (not left_way)
		|| curr_dir == "up" and (not up_way)
		|| curr_dir == "down" and (not down_way)):
			#pac-man can not move
			can_move = false
			#adjust pac-man's position
			adjust_position()

#checks if pac-man left a turn point (var body is the turn point)
func _on_turn_point_check_body_exited(_body):
	#pac-man is no longer on a turn point
	#set current turn point to null
	curr_point = null
	
	#no longer sure if pac-man can go up, right, down, or left
	#set all bools connected to the possible directions to false
	right_way = false
	left_way = false
	up_way = false
	down_way = false
	
	#pac-man can now move since turn points do serve as dead ends
	#since pac-man is not at a turn point, it's not at a dead end
	#thus it can move
	can_move = true

#signal that runs when the super timer runs out of time
func _on_super_timer_timeout():
	is_super = false
	print("not super")

func _on_ghost_check_body_entered(body):
	if (is_super):
		body.kill()
	else:
		get_parent().load_lose()
