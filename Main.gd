extends Node


# Object who contains the Virus node.
#export (PackedScene) var viruScene


#  Define global varaiables
onready var WiteEndTimer = $WiteEndTimer

var score = 0
var isMessageShown = false
var soundPlayer = false
var lives = 0
var playDeath = true





# This function is executed when call the file
func _ready():
	"""
	This function change the layer position of the Hud
	"""
	
	# Change the layers of the sprite
	$Hud.set_layer(3)
	$CanvasLayer.set_layer(2)
	$Score.set_layer(1)

	



# This function control what apear in the screen when show questions
func questions():
	"""
	This function is connected to the hit signal from Player.gd.
	When player is hited show a question.
	
	Questions function is responsible to control the question when it appear in the screen
	it control the layers, musics, timers, and lives.
	"""



	# Change the zindex (the layer) of the sprite
	$Hud.set_layer(2)
	$CanvasLayer.set_layer(3)
	$Score.set_layer(1)
	
	# Stop the music
	$Music.stop()
	
	# Stop the timers
	$VirusTimer.stop()
	$ScoreTimer.paused = true
	
	# Disable the player hitbox of the player
	$Player/CollisionShape2D.set_deferred("disabled", true)
	
	# Hide the player
	$Player.hide()
	
	# Hide hud label
	$Hud/MessageLabel.hide()
	
	# Hide hud button
	$Hud/Start.hide()
	
	
	# If lives are more than 0
	if lives > 0:
		# Call request function
		$CanvasLayer/Control.request()
		
		# If the answer has wrong call the funcion _on_Control_Wrong()
		if has_signal("Wrong"):
			_on_Control_Wrong()
			
		# If the answer has correct call funcion the _on_Control_Correct()
		if has_signal("Correct"): 
			_on_Control_Correct()
	
	# If lives are equal to 0 call game_over() function
	if lives == 0:
		game_over()






# This function control what happears in the screen when start a new game
func new_game():
	"""
	This function is connected to the start_game signal from Hud.gd.
	When start button is pressed call new_game function.
	
	Here update the score and lives, and start music and timers.
	"""
	
	# Define default values for the funcitons
	lives = 3
	
	# Pass values to the update functions
	$Hud.update_lives(lives)
	#$Hud.update_score(score)
	
	# Start timer
	$StartTimer.start()
	
	# Start music
	$Music.play()
	
	# Display the player
	$Player.start(527, 301)
	
	# Stop the execution and call the timeout of StartTimer
	yield($StartTimer, "timeout")
	
	# Start timers
	$ScoreTimer.start()
	$VirusTimer.start()




# This function control what is showing when end the game
func game_over():
	"""
	This function is called when the lives are 0 and is the responsible to prepare
	the timers and music to the new game.
	"""
	
	# Change layers
	$Hud.set_layer(1)
	$CanvasLayer.set_layer(2)
	$Score.set_layer(5)

	# Stop timers
	$ScoreTimer.stop()
	$VirusTimer.stop()

	# Stop music
	$Music.stop()
	
	if playDeath:
		# Play death sound
		$Death.play()
		playDeath = false

	# Check if the timeout state of WiteEndTimer is connected to _on_WiteEndTimer_timeout function
	if not WiteEndTimer.is_connected("timeout", self, "_on_WiteEndTimer_timeout"):

			# Connect timeout to _on_WiteEndTimer_timeout function
			WiteEndTimer.connect("timeout", self, "_on_WiteEndTimer_timeout")
	
	# Start the WiteEndTimer timer 
	WiteEndTimer.start()
	
	# Display the score
	$Score.printLabel(score)
	$Score.show()

	# Call sendScore funciton 
	sendScore()


# This function change the scene
func _on_WiteEndTimer_timeout():
	"""
	This function is called when the WiteEndTimer timer ends,
	and is the responsible to change to the main scene.
	"""
	
	# Change the scene to the main scene
	$Score.hide()
	get_tree().change_scene("res://Main.tscn")



# This function control the visus spawn location
func _on_VirusTimer_timeout():
	"""
	This function is connected to the VirusTimer, and it's executed when the timer
	ends.
	
	It's the responsible to control the virus spawn location, velocitis and directions.
	"""
	
	# Get the spawn location of the Virus node.
	var viruSpawnLocation = $VirusPath2D/ViruSpawn
	
	# Set a random value to the spawn location.
	viruSpawnLocation.unit_offset = randf()
	
	# Load the virus scene data
	var viruScene  = load("res://virus.tscn")
	
	# Instantiate a new Virus node from the object 
	# and add it as a child.
	var virus = viruScene.instance()
	add_child(virus)
	
	# Set the position of the new Virus to the spawn location.VirusTimer
	virus.position = viruSpawnLocation.position
	
	# Calculate a random direction for the new Virus.
	var direction = viruSpawnLocation.rotation + PI / 2
	direction += rand_range( - PI / 4,  PI / 4 )
	
	
	# Set the rotation of the new Virus to the calculated direction.
	virus.rotation = direction
	
	# Calculate a random velocity for the new Virus 
	# and set it to move in the calculated direction.
	var velocity = Vector2(rand_range(virus.minSpeed, virus.maxSpeed), 0)
	virus.linear_velocity = velocity.rotated(direction)




# This function control the score is updated in a concret time
func _on_ScoreTimer_timeout():
	"""
	This function is connected to the ScoreTimer, and it's executed when the timer
	ends.
	
	This function update the score value adding 1 to the previous value constantly
	"""
	
	# Update the score value
	score += 1
	
	# Give the score value to the update_score function
	$Hud.update_score(score)
	
	# Hide the missage if it is showing
	if isMessageShown:
		$Hud.showMessage("")
		#isMessageShown = false




# This function managment when the answer is wrong  
func _on_Control_Wrong():
	"""
	This function is connected to the wrong signal from Control.gd.
	
	Here update the lives, display the player and restart the timers and music.
	"""
	
	# Subtract a live
	lives -= 1
	
	# Show hud node
	$Hud.show()
	
	# Give the new lives value to update_lives function
	$Hud.update_lives(lives)
	
	# Show player in the midle of the screen
	$Player.start(527, 301)
	
	# Start timer
	$VirusTimer.start()

	# Restart the counter 
	$ScoreTimer.paused = false
	
	# Play music
	$Music.play()
	
	# Start the timer who abilite the player hitbox
	$Player/WaitTimer.start()
	
	# Disable the selection from the options list
	$CanvasLayer/Control.disable()
	



# This function managment when the answer is correct  
func _on_Control_Correct():
	"""
	This function is connected to the correct signal from Control.gd.
	
	Here display the player and restart the timers and music.
	"""
	
	# Show player in the midle of the screen
	$Player.start(527, 301)
	
	# Show the hud node
	$Hud.show()
	
	# Start timer
	$VirusTimer.start()

	# Restart the counter
	$ScoreTimer.paused = false
	
	# Play music
	$Music.play()
	
	# Start the timer who abilite the player hitbox
	$Player/WaitTimer.start()
	
	# Disable the selection from the options list
	$CanvasLayer/Control.disable()



# This function send the socre to the server
func sendScore():
	"""
	This function create a dictionary and call the function sendData
	"""
	
	# Test setItem
	# var storeuser = JavaScript.eval("localStorage.setItem('user_id', 1)")
	
	# Get the user_if from localstorage
	var result = JavaScript.eval("localStorage.getItem('user_id')")

	# Save data in a variable
	var sendscore = score
	
	# Define a dictionary with the strings formated before
	var origin: Dictionary = {"puntuation":sendscore, "user_id":result, "topic_id":1}

	# Call sendOriginalData function
	$DataBase.sendData(origin)
