#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines Super Pac-Dot objects

#gets all the attributes of Area2D
extends Area2D

#signal that runs everytime pac-man collides with super pac dot
func _on_body_entered(body):
	#pac-man is now in its super mode
	body.is_super = true
	#remove self
	queue_free()
