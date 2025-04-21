#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines Pac-Dot object

#gets all the attributes of Area2D
extends Area2D

#signal that runs when a body enters the dot
func _on_body_entered(_body):	
	#removes self
	if (visible):
		get_parent().my_dots -= 1
		visible = false

func _on_pinky_area_check_area_entered(area):
	area.get_parent().pinky_dot = self

func _on_inky_area_check_area_entered(area):
	area.get_parent().inky_dot = self

func _on_inky_area_check_area_exited(area):
	area.get_parent().inky_dot = null
