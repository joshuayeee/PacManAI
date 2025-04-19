#Author: Joshua Yee
#Date Last Edited: April 16, 2025
#Purpose: Defines Clyde's target

#gets all the attributes of Node2D
extends Node2D

#signal that runs when blinky enters the target object
func _on_area_2d_body_entered(body):
	#check if the body is blinky
	if (body is Clyde):
		#check if the state is chase
		if (body.state == "chase"):
			#create a target object that will be spawned at pac-man's position
			body.create_target("pac-man")
		#check if the state is run
		elif (body.state == "run"):
			#create a target object that will be spawned at the corner
			body.create_target("corner")
	#remove
	queue_free()
