#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines title screen

#gets all the attributes of Node2D
extends Node2D

#signal that runs when the start button is pressed
func _on_start_button_pressed():
	#gets the main object, make it call the load scene function
	#loads the main level
	get_parent().load_scene("main_level")

#signal that runs when the exit button is pressed
func _on_exit_button_pressed():
	#exit the game
	get_tree().quit()
