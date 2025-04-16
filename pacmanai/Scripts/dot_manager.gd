#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines the dot manager

#gets all the attributes of Node2D
extends Node2D

func _process(_delta):
	#check if child count is equal to or below zero
	if (get_child_count() <= 0):
		#pac-man wins
		
		#load win screen
		get_parent().load_win()
