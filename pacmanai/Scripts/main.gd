#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines Main

#gets all the attributes of Node
extends Node

#constant that loads the file location of the title screen
const TITLE_SCREEN = preload("res://Scenes/title_screen.tscn")
#constant that loads the file location of the main level
const MAIN_LEVEL = preload("res://Scenes/main_level.tscn")
#constant that loads the file location of the game over screen
const GAME_OVER_SCREEN = preload("res://Scenes/game_over_screen.tscn")
#constant that loads the file location of the win screen
const WIN_SCREEN = preload("res://Scenes/win_screen.tscn")

#holds the current scene that is loaded
var curr_scene = null

#runs as soon as the object is created
func _ready():
	#load the title screen
	load_scene("title_screen")

#loads a scene and adds it as a child
#uses scene name as a way to determine which scene to load
func load_scene(scene_name):
	#check if the current scene is not null
	if (curr_scene != null):
		#there is already a scene loaded
		#remove the current scene
		curr_scene.queue_free()
		#set the var holding current scene to null
		curr_scene = null
	
	#check the scene name
	if (scene_name == "main_level"):
		#load the main level scene
		curr_scene = MAIN_LEVEL.instantiate()
	elif (scene_name == "title_screen"):
		#load the title screen scene
		curr_scene = TITLE_SCREEN.instantiate()
	elif (scene_name == "game_over_screen"):
		#load the game over screen scene
		curr_scene = GAME_OVER_SCREEN.instantiate()
	elif (scene_name == "win_screen"):
		#load the win screen scene
		curr_scene = WIN_SCREEN.instantiate()
	
	#check if current scene is not null
	if (curr_scene != null):
		#add the current scene as a child
		add_child(curr_scene)
