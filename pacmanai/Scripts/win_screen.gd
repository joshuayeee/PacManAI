#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines Win Screen

#gets all the attributes of Node2D
extends Node2D

#signal that runs when the back button is pressed
func _on_back_button_pressed():
	#get main object
	#load the title screen
	get_parent().load_scene("title_screen")
