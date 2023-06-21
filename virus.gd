"""
File: virus.gd
Description: This file manages the virus
Author: Martí Llurba
Date: 10/05/2023
Version: 1.0
"""

extends RigidBody2D

# Export max and min speed variable
export var maxSpeed = 180.0
export var minSpeed = 150.0




# This function is executed when call the file
func _ready():
	"""
	In this function select a random frame and display the frame in the screen.
	"""
	
	# Randomize the animation frame
	randomize()
	
	# Set the AnimatedSprite to play its animation
	$AnimatedSprite.playing = true
	
	# Get the names of all the animations 
	var virusTypes = $AnimatedSprite.frames.get_animation_names()
	
	# Set the animation to a random animation from the list of animations
	$AnimatedSprite.animation = virusTypes[randi() % virusTypes.size()]




# This function control the virus when exit the screen
func _on_VisibilityNotifier2D_screen_exited():
	"""
	This function delete the virus of the memory when exit the screen
	"""
	
	# Remove virus from the memory
	queue_free()

