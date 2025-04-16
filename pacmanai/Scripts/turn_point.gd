#Author: Joshua Yee
#Date Last Edited: April 15, 2025
#Purpose: Defines turn point object

#gets all the attributes of StaticBody2D
extends StaticBody2D

#SIDENOTE: @export allows the var to be edited in the UI
#bool that determines if pac-man can move right
@export var right_way = false
#bool that determines if pac-man can move left
@export var left_way = false
#bool that determines if pac-man can move up
@export var up_way = false
#bool that determines if pac-man can move down
@export var down_way = false
