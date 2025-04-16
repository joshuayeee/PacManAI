#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines Game Over Screen

#gets all the attributes of Node2D
extends Node2D

#signal that runs when the back button is pressed
func _on_back_button_pressed():
	#gets main object
	#loads the title screen scene 
	get_parent().load_scene("title_screen")
