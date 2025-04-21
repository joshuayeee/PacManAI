# Author: Joshua Yee and Phat Pham
# Date Last Edited: April 20, 2025
# Purpose: Defines Clyde's AI behavior with classic chase/retreat logic

class_name Clyde
extends CharacterBody2D

const SPEED = 200.0
const FAST_SPEED = 300.0
const RUN_SPEED = 100.0

const FLIP_POINT = 592
const RETREAT_DISTANCE = 300  # Distance threshold for retreating

const CLYDE_TARGET = preload("res://Scenes/clyde_target.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var start_position
var speed

var right_way = false
var left_way = false
var down_way = false
var up_way = false

var curr_dir = "right"
var can_move = true
var target_pos = null

var pac_man = null
var corner = null
var dot_manager = null

var angry_amount
var is_angry = false
var state = "chase"

var dist_to_pacman
var curr_target = null
var curr_target_name = null

func _ready():
	start_position = position
	pac_man = get_parent().get_node("PacMan")
	dot_manager = get_parent().get_node("DotManager")
	corner = get_parent().get_node("ClydeCorner")
	angry_amount = dot_manager.get_child_count() / 2
	set_state("chase", "pac-man")

func _physics_process(delta):
	if position == start_position:
		curr_dir = "right"

	if target_pos != null:
		if can_move:
			match curr_dir:
				"right":
					velocity.x = speed
					velocity.y = 0
				"left":
					velocity.x = -speed
					velocity.y = 0
				"up":
					velocity.y = -speed
					velocity.x = 0
				"down":
					velocity.y = speed
					velocity.x = 0
			move_and_slide()

		if not is_angry and dot_manager.get_child_count() <= angry_amount and state != "run":
			speed = FAST_SPEED
			is_angry = true

		if pac_man.is_super and state != "run":
			set_state("run", "")
		elif not pac_man.is_super and state == "run":
			set_state("chase", "pac-man")

		if position.x > FLIP_POINT:
			position.x = -FLIP_POINT
		elif position.x < -FLIP_POINT:
			position.x = FLIP_POINT
	
	if (state != "run"):
		dist_to_pacman = get_distance(position, pac_man.position)
		if (dist_to_pacman < RETREAT_DISTANCE):
			set_state("chase", "corner")
		else:
			set_state("chase", "pac-man")

func _on_turn_point_check_body_entered(body):
	right_way = body.right_way
	left_way = body.left_way
	up_way = body.up_way
	down_way = body.down_way

	can_move = false
	adjust_position(body.position)
	calc_heuristics()

func _on_turn_point_check_body_exited(body):
	right_way = false
	left_way = false
	up_way = false
	down_way = false

func adjust_position(new_pos):
	position = new_pos

func calc_heuristics():
	var vals = {}
	var temp_pos

	if right_way and curr_dir != "left":
		temp_pos = position
		temp_pos.x += 1
		vals["right"] = get_distance(temp_pos, target_pos)

	if left_way and curr_dir != "right":
		temp_pos = position
		temp_pos.x -= 1
		vals["left"] = get_distance(temp_pos, target_pos)

	if up_way and curr_dir != "down":
		temp_pos = position
		temp_pos.y -= 1
		vals["up"] = get_distance(temp_pos, target_pos)

	if down_way and curr_dir != "up":
		temp_pos = position
		temp_pos.y += 1
		vals["down"] = get_distance(temp_pos, target_pos)

	var best_h_val = -1
	var best_move = ""

	for key in vals.keys():
		if best_h_val == -1 or vals[key] < best_h_val:
			best_h_val = vals[key]
			best_move = key

	curr_dir = best_move

	if state != "run":
		match curr_dir:
			"right": animated_sprite_2d.play("right_move")
			"left": animated_sprite_2d.play("left_move")
			"up": animated_sprite_2d.play("up_move")
			"down": animated_sprite_2d.play("down_move")

	can_move = true

func get_distance(point1, point2):
	return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))

func create_target(target_name):
	var make_new_target = false
	if target_name == "pac-man" and curr_target_name != "pac-man":
		target_pos = pac_man.position
		curr_target_name = "pac-man"
		make_new_target = true
	elif target_name == "corner" and curr_target_name != "corner":
		target_pos = corner.position
		curr_target_name = "corner"
		make_new_target = true
	
	if (make_new_target):
		if (curr_target != null):
			curr_target.queue_free()
			curr_target = null
		curr_target = CLYDE_TARGET.instantiate()
		curr_target.global_position = target_pos
		get_parent().add_child.call_deferred(curr_target)


func set_state(state_name, target_name):
	if state_name == "chase":
		# Dynamic targeting: chase Pac-Man unless close, then retreat
		create_target(target_name)
		speed = SPEED
	elif state_name == "run":
		create_target("corner")
		animated_sprite_2d.play("run")
		is_angry = false
		speed = RUN_SPEED
	state = state_name

func kill():
	position = start_position
	curr_dir = "right"
	right_way = false
	left_way = false
	down_way = false
	up_way = false
	set_state("chase", "pac-man")
