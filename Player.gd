"""
File: Player.gd
Description: This file manages the player
Author: Martí Llurba
Date: 10/05/2023
Version: 1.1
"""

extends Area2D

# Send the signal to call them in an other file
signal hit

# Export the speed of the player 
export var speed = 400.0

# Define global variables
var screenSize = Vector2.ZERO
var hasBeenHit = false


# This function is executed when call the file
func _ready():
	"""
	This function hide the player defaultly and save the screen size
	"""
	
	# Hide the player when the script is executed
	$AnimatedSprite.hide()
	
	# Get the size of the game window
	screenSize = get_viewport_rect().size




# This function control the player movment
func _physics_process(delta):
	"""
	This function control the player movment 
	"""
	
	# Define direction is 0
	var direction = Vector2.ZERO
	
	# Update direction based on the input action 
	if Input.is_action_pressed("right"):
		direction.x += 1
		
	elif Input.is_action_pressed("left"):
		direction.x -= 1
	
	elif Input.is_action_pressed("down"):
		direction.y += 1
		
	elif Input.is_action_pressed("up"):
		direction.y -=1
	
	# If the direction vector has a length greater than 1
	if direction.length() > 1:
		
		# Normalize the direction vector to keep a consistent speed
		direction = direction.normalized()
		
		# Play the animation on the AnimatedSprite node
		$AnimatedSprite.play()
		
	else: 
		
		# Stop the animation on the AnimatedSprite node
		$AnimatedSprite.stop()
		
	# Update the player's position based on the direction vector, speed, and delta time
	position += direction * speed * delta
	
	# Clamp the player's position within the screen bounds
	position.x = clamp(position.x, +10, screenSize.x -10)
	position.y = clamp(position.y, +10, screenSize.y -10)
	
	
	# If the player is moving horizontally
	if direction.x != 0:
		
		# Set animation
		$AnimatedSprite.animation = "player"
		
		#Flip AnimatedSprite horizontally
		$AnimatedSprite.flip_h = direction.x < 0
		
		# Flip AnimatedSprite verticaly
		$AnimatedSprite.flip_v = false
		
	# If the player is moving vertically
	elif direction.y != 0:
		
		# Set animation
		$AnimatedSprite.animation = "player"
		
		# Flip AnimatedSprite verticaly
		$AnimatedSprite.flip_v = direction.y < 0
		
		#Flip AnimatedSprite horizontally
		$AnimatedSprite.flip_h = false



# This position control the start position of the player
func start(pos_x, pos_y):
	"""
	This function is given 2 parameters, this parameters difine the x and y position
	of the player in the screen.
	"""
	
	# Update the position value with the values gived
	position = Vector2(pos_x, pos_y)
	
	# Update the variable value
	hasBeenHit = false
	
	# Show the player
	show()
	$AnimatedSprite.show()




# This function control what happens with the player when it is hitted
func _on_Player_body_entered(_body):
	"""
	This function is connected to the Player node and is executed when the node
	detect something in the range definied by the collision shape.
	
	This function receives a bool parameter and is responsible for its execution
	"""
	
	# Check if the player is not hit before
	if not hasBeenHit:
		
		# Update the variable value
		hasBeenHit = true
		
		# Hide the player
		hide()
		
		
		# Send "hit" signal
		emit_signal("hit")




# This function enalbe the player hitbox with a waiting time
func _on_WaitTimer_timeout():
	"""
	This function is connectet with a timer, when the timer ends execute this function.
	"""
	
	# Enable the CollisionShape2D
	$CollisionShape2D.set_deferred("disabled", false)


