extends CanvasLayer

# Send the signal to call them in an other file
signal start_game


# This function update the lives value
func update_lives(lives):
	"""
	This function recive the lives value (the lives who have the player),
	and update the lives value in the screen
	"""
	
	# Display the lives value gived 
	$HBoxContainer/LivesContainer/LivesValue.text = str(lives)




# This function update the score value
func update_score(score):
	"""
	This function recive the score value, (the score who have the player),
	and update the in the screen
	"""
	
	# Display the score value gived 
	$HBoxContainer/SocreContainer/ScoreValue.text = str(score)

# This function update the MessageLabel value
func showMessage(text):
	"""
	This function receive the text value, (a text specified when the function is called),
	and display them in the screen
	"""
	
	# Display the text value gived
	$MessageLabel.text = text
	$MessageLabel.show()




# This function send a signal to start the game
func _on_Start_pressed():
	"""
	This function is connected to the start button,
	when the button is presset execute this function.
	
	Here hide the button and the message, and in the end
	send the start_game signal.
	"""
	
	# Hide the button and the message 
	$Start.hide()
	$MessageLabel.hide()
	
	
	# Send "start_game" signal
	emit_signal("start_game")




# This function hide the message label
func _on_MessageTimer_timeout():
	"""
	This function is connected with a timer,
	when the timer arrive to 0 hide the label.
	"""
	
	# Hide label
	$MessageLabel.hide()


