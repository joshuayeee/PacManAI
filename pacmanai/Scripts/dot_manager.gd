#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines the dot manager

#gets all the attributes of Node2D
extends Node2D

var my_dots = 100

func _ready():
	my_dots = get_child_count()

func _process(_delta):
	#check if child count is equal to or below zero
	if (my_dots <= 0):
		#pac-man wins
		
		#load win screen
		get_parent().load_win()
