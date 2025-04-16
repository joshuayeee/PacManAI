#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines Pac-Dot object

#gets all the attributes of Area2D
extends Area2D

#signal that runs when a body enters the dot
func _on_body_entered(_body):	
	#removes self
	queue_free()
