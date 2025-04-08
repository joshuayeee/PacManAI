#gets methods and vars from CharacterBody2D
extends CharacterBody2D

#speed of pac-man
const SPEED = 300.0

#helps determine if pac-man is at a Turn Point
var at_turn_point = false

var right_way = false
var left_way = false
var up_way = false
var down_way = false

var curr_dir = "right"

var can_move = true

var is_hori = true

#function that runs every frame (optimized for physics)
func _physics_process(delta: float) -> void:
	if (is_hori):
		if (Input.is_action_pressed("right")):
			curr_dir = "right"
		elif (Input.is_action_pressed("left")):
			curr_dir = "left"
			
		if (Input.is_action_pressed("up") and up_way):
			curr_dir = "up"
			is_hori = false
			
		if (Input.is_action_pressed("down") and down_way):
			curr_dir = "down"
			is_hori = false
			
	else:
		if (Input.is_action_pressed("up")):
			curr_dir = "up"
		elif (Input.is_action_pressed("down")):
			curr_dir = "down"
			
		if (Input.is_action_pressed("right") and right_way):
			curr_dir = "right"
			is_hori = true
			
		if (Input.is_action_pressed("left") and left_way):
			curr_dir = "left"
			is_hori = true
	
	if (can_move):
		pass

#checks if pac-man is at a turn point
func _on_turn_point_check_body_entered(body: Node2D) -> void:
	right_way = body.right_way
	left_way = body.left_way
	up_way = body.up_way
	down_way = body.down_way
	
	if (curr_dir == "right" and (not right_way)
		|| curr_dir == "left" and (not left_way)
		|| curr_dir == "up" and (not up_way)
		|| curr_dir == "down" and (not down_way)):
			can_move = false

#checks if pac-man left a turn point
func _on_turn_point_check_body_exited(body: Node2D) -> void:
	right_way = false
	left_way = false
	up_way = false
	down_way = false
