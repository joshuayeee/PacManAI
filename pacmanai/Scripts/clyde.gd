#Author: Joshua Yee
#Date Last Edited: April 18, 2025
#Purpose: Defines Clyde's AI behavior

#defines the class name
class_name Clyde

#gets all the attributes of CharacterBody2D
extends CharacterBody2D

#normal speed
const SPEED = 200.0
#anger speed
const ANGER_SPEED = 300.0
#run speed
const RUN_SPEED = 100.0

#point where clyde moves to the other side of the screen
const FLIP_POINT = 592

#target object that clyde moves towards
const CLYDE_TARGET = preload("res://Scenes/clyde_target.tscn")

#handles clyde's animated sprite
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#the position that clyde first starts at
var start_position

#the actual speed that clyde runs at
var speed
#helps check if clyde can go right
var right_way = false
#helps check if clyde can go left
var left_way = false
#helps check if clyde can go down
var down_way = false
#helps check if clyde can go up
var up_way = false

#the current direction clyde is heading towards
var curr_dir = "right"

#helps check if clyde can move
var can_move = true

#the position of the target object
var target_pos = null

#var that contains pac-man
var pac_man = null

#var that contains the corner object
var corner = null

#var that contains the dot manager
var dot_manager = null

#the amount of dots that determines if clyde turns angry or not 
var angry_amount

#helps determine if clyde is angry
var is_angry = false

#helps determine what state clyde is in
var state = "chase"

#runs as soon as clyde is ready
func _ready():
	#sets up the starting position
	start_position = position
	#gets pac-man
	pac_man = get_parent().get_node("PacMan")
	#gets the dot manager
	dot_manager = get_parent().get_node("DotManager")
	#gets the corner object
	corner = get_parent().get_node("ClydeCorner")
	#sets up the angry amount
	angry_amount = dot_manager.get_child_count() / 2
	
	#sets the state to chase state
	set_state("chase")

#function that runs every frame (optimized for physics)
func _physics_process(delta):
	#makes sure that clyde goes right when they are at the starting position
	if (position == start_position):
		#set the current direction to right
		curr_dir = "right"
	
	#check if the target's position exists
	if (target_pos != null):
		#check if clyde can move
		if (can_move):
			#check if the current direction is right
			if (curr_dir == "right"):
				#move clyde right
				velocity.x = speed
				velocity.y = 0
			#check if the current direction is left
			elif (curr_dir == "left"):
				#move clyde left
				velocity.x = -speed
				velocity.y = 0
			#check if the current direction is up
			elif (curr_dir == "up"):
				#move clyde up
				velocity.y = -speed
				velocity.x = 0
			#check if the current direction is down
			elif (curr_dir == "down"):
				#move clyde down
				velocity.y = speed
				velocity.x = 0
			#godot's built in function that helps handle movement physics
			move_and_slide()
		#check if clyde is not angry and that the angry amount has been reached and that the current state is not run
		if (not is_angry and dot_manager.get_child_count() <= angry_amount and state != "run"):
			#set blinky's speed as anger speed
			speed = ANGER_SPEED
			#blinky is now angry
			is_angry = true
		
		#check if pac-man is in its super mode
		#also check if the state does not equal run
		if (pac_man.is_super and state != "run"):
			#set blinky's state to run
			set_state("run")
		#check if pac-man is not in its super mode
		#also check if the state equals run
		elif ((not pac_man.is_super and state == "run")):
			#set clyde's state to chase
			set_state("chase")
		
		#check if clyde's position is beyond flip point
		if (position.x > FLIP_POINT):
			#move clyde to the other side of the screen
			position.x = -FLIP_POINT
		#check if clyde's position is beyond negative flip point
		elif (position.x < -FLIP_POINT):
			#move clyde to the other side of the screen
			position.x = FLIP_POINT

#signal that runs when clyde collides with a turn point
func _on_turn_point_check_body_entered(body):
	#check if clyde can go right from the turn point
	right_way = body.right_way
	#check if clyde can go left from the turn point
	left_way = body.left_way
	#check if clyde can go up from the turn point
	up_way = body.up_way
	#check if clyde can go down from the turn point
	down_way = body.down_way
	
	#clyde can no longer move
	can_move = false
	#adjust clyde's position to the turn point
	adjust_position(body.position)
	#calculate heuristic values
	calc_heuristics()

#signal that runs when clyde leaves a turn point
func _on_turn_point_check_body_exited(body):
	#can not be determined if clyde can move in any direction
	#set all possible directions to false
	right_way = false
	left_way = false
	up_way = false
	down_way = false

#set clyde's position to given parameter
func adjust_position(new_pos):
	#set clyde's position to the new position
	position = new_pos

#calculates all heuristic values
func calc_heuristics():
	#dictionary of heuristic values
	var vals = {}
	#temporary position
	var temp_pos
	#check if clyde can go right
	#also check if clyde is not going left
	if (right_way and curr_dir != "left"):
		#set temp position to clyde's current position
		temp_pos = position
		#move temp's position 1 to the right
		temp_pos.x += 1
		#get the distance between the temp position and the target's position
		var h_val_right = get_distance(temp_pos, target_pos)
		#add to the vals dictionary with the right h value
		vals["right"] = h_val_right
	
	#check if clyde can go left
	#also check if clyde is not going right
	if (left_way and curr_dir != "right"):
		#set temp position to clyde's current position
		temp_pos = position
		#set temp position 1 to the left
		temp_pos.x -= 1
		#get the distance between the temp position and the target position
		var h_val_left = get_distance(temp_pos, target_pos)
		#add to the vals dictionary with the left h value
		vals["left"] = h_val_left
	
	#check if clyde can go up
	#also check if clyde is not going down
	if (up_way and curr_dir != "down"):
		#set the temp position to clyde's current position
		temp_pos = position
		#move the temp position up 1 pixel
		temp_pos.y -= 1
		#get the distance between the temp position and the target position
		var h_val_up = get_distance(temp_pos, target_pos)
		#add to the vals dictionary with the up h value
		vals["up"] = h_val_up
	
	#check if clyde can go down
	#also check if clyde's current direction is not up
	if (down_way and curr_dir != "up"):
		#set the temp position to clyde's current position
		temp_pos = position
		#set the temp position 1 pixel down
		temp_pos.y += 1
		#get the distance between the temp position and the target position
		var h_val_down = get_distance(temp_pos, target_pos)
		#add to the vals dictionary with the down h value
		vals["down"] = h_val_down
	
	#set the best possible h value to -1
	var best_h_val = -1
	#set the best move to ""
	var best_move = ""
	#for each key in the vals dictionary
	for key in vals.keys():
		#check if the best h value is equal to -1
		if (best_h_val == -1):
			#set the best h value to the first dictionary entry
			#set the best h value to the value at the current key
			best_h_val = vals[key]
			#set the best move to the current key
			best_move = key
		else:
			#check if the value at the current key is less than the best h value
			if (vals[key] < best_h_val):
				#set the best h value to the value in the current key
				best_h_val = vals[key]
				#set the best move to the current key
				best_move = key
	#set the current direction to the best move
	curr_dir = best_move
	
	#check if clyde's state does not equal run
	if (state != "run"):
		#check what direction clyde is moving in
		#set the animation to the corresponding direction
		if (curr_dir == "right"):
			animated_sprite_2d.play("right_move")
		elif (curr_dir == "left"):
			animated_sprite_2d.play("left_move")
		elif (curr_dir == "up"):
			animated_sprite_2d.play("up_move")
		elif (curr_dir == "down"):
			animated_sprite_2d.play("down_move")
	#clyde can now move
	can_move = true

#calculates the distance between two positions
func get_distance(point1, point2):
	#returns the distance betweem two positions
	return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))

#function that creates the target object
func create_target(target_name):
	#check if the target's name is pac-man
	if (target_name == "pac-man"):
		#set the target's position to equal to pac-man's current position
		target_pos = pac_man.position
	#check if the target's name is corner
	elif (target_name == "corner"):
		#set the target's position to equal corner's position
		target_pos = corner.position
	
	#set up the target object
	var my_target = CLYDE_TARGET.instantiate()
	#set the target's position
	my_target.global_position = target_pos
	#spawn the target position into the game
	get_parent().add_child.call_deferred(my_target)

#function that sets the state of blinky
func set_state(state_name):
	#check if the state name is chase
	if (state_name == "chase"):
		#create a target object that will be spawned at pac-man's position
		create_target("pac-man")
		#set clyde's speed to the normal speed
		speed = SPEED
	elif (state_name == "run"):
		#create a target object that will be spawned at the corner
		create_target("corner")
		#play the run animation
		animated_sprite_2d.play("run")
		#clyde is no longer angry
		is_angry = false
		#set clyde's speed to the run speed
		speed = RUN_SPEED
	#set the state depending on state name
	state = state_name

#function that handles when super pac-man catches clyde
func kill():
	#set clyde's position to the start position
	position = start_position
	#set clyde's current direction to right
	var curr_dir = "right"
	#clyde can no longer go any direction at the moment
	var right_way = false
	var left_way = false
	var down_way = false
	var up_way = false
	#set clyde's state to chase
	set_state("chase")
