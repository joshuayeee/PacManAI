#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines main level

#gets all the attributes of Node2D
extends Node2D

#loads the win screen
func load_win():
	#gets parent object (main)
	#loads win screen scene
	get_parent().load_scene("win_screen")
