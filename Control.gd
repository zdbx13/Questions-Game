extends Control

# Send the signals to call them in an other file
signal Wrong
signal Correct
signal finished


# Define global variables
onready var DisplayText = $Popup/VBoxContainer/Label
onready var ListItem = $Popup/VBoxContainer/ItemList
onready var Ctimer = $CorrectTimer
onready var Wtimer = $WrongTimer
onready var isConected = false

var JsonData




# This function is executed when call the file
func _ready(): 
	"""
	In this function call hideCoponents function.
	"""
	
	# Call hideCoponents fucntion
	hideCoponents()




# This function hide components
func hideCoponents():
	"""
	This function hide all components
	"""
	
	# Hide all components
	$ColorRect.hide()
	$Popup/ResponceLabel.hide()
	$Popup/VBoxContainer/Label.hide()
	$Popup/VBoxContainer/ItemList.hide()
	
	

# This function update the JsonData variable value
func JSData(Data):
	"""
	This function recive "Data", the data who contain the request_finished signal,
	received from DataBase.gd, and update the JsonData value.
	"""
	
	# Update the varible value
	JsonData = Data
	
	# Emit a signal
	emit_signal("finished")




# This function make a new request
func request():
	"""
	This function make a new request calling make_request function.
	"""
	
	# Call make_request fucntion
	$DataBase.make_request()




# This function show the question and there options
func show_question():
	"""
	This function is connected to finished signal from JSData function, and  
	displays the components you need to view the questions.
	"""
	
	# Call hideCoponents function
	hideCoponents()

	# Clear the item list options 
	ListItem.clear()
	
	
	# Enable the option selection
	enable()
	
	# Save the JsonData values in to a local variables
	var opt1 	 = JsonData.option1
	var opt2 	 = JsonData.option2
	var opt3 	 = JsonData.option3
	var opt4 	 = JsonData.option4
	var question = JsonData.question
	
	# Save the options in a dictionary
	var options = [opt1, opt2, opt3, opt4]
	
	# Display question
	DisplayText.text = question
	
	# Display the options
	for option in options:
		ListItem.add_item(option)
		
	# Show components
	$ColorRect.show()
	$Popup.show()
	$Popup/VBoxContainer/Label.show()
	$Popup/VBoxContainer/ItemList.show()



# This function check the answer
func _on_ItemList_item_selected(index):
	"""
	This function recive a index value (the option selected),
	and compare them to the correct option defined in the request.
	Depends the response it emit a correct or wrong signal.
	"""
	
	# Define Responcelabel into a variable
	var label = $Popup/ResponceLabel
	
	# If answer is correct 
	if index ==  JsonData.correctOptionIndex -1:
		#print("Checker", JsonData.correctOptionIndex -1)
		
		# Display text message and select them color
		label.show()
		label.modulate = Color(1, 0.843, 0)
		label.text = ("Correct")

		# Play a sound
		$Popup/Correct.play()
		
		# Check if the signal is connected
		if not Ctimer.is_connected("timeout", self, "_on_CorrectTimer_timeout"):
			
			# Connect the signal timeout to _on_CorrectTimer_timeout function
			Ctimer.connect("timeout", self, "_on_CorrectTimer_timeout")
		
		# Start timer
		Ctimer.start()
	
		# Call disable function
		disable()
		

	
	# If answer is not correct
	else:
		
		# Change the bakground of the correct option
		ListItem.set_item_custom_bg_color(JsonData.correctOptionIndex -1, Color("911414"))

		# Display text message and select them color
		label.show()
		label.modulate = Color(255, 0, 0)
		label.text = ("Incorrect")
		
		# Play a sound
		$Popup/Wrong.play()
		
		# Check if the signal is connected
		if not Wtimer.is_connected("timeout", self, "_on_WrongTimer_timeout"):
			
			# Connect the signal timeout to _on_CorrectTimer_timeout function
			Wtimer.connect("timeout", self, "_on_WrongTimer_timeout")
		
		# Start timer
		Wtimer.start()
			
		# Call disable function
		disable()
		


# This function disable the selection to response options
func disable():
	"""
	This function ignore all the mouse touches if
	you selected an option previously.
	"""
	
	# Define Popup/VBoxContainer/ItemList into a variable
	var item_list = $Popup/VBoxContainer/ItemList
	
	# Ignore the mouse selection
	item_list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Apply the changes to all option
	for item in range(item_list.get_item_count()):
		item_list.set_item_disabled(item, true)




# This function enable the selection to response options
func enable():
	"""
	This function allow all the mouse touches.
	"""
	
	# Define Popup/VBoxContainer/ItemList in a variable
	var item_list = $Popup/VBoxContainer/ItemList
	
	# Hear the mouse selection
	item_list.mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Apply the changes to all option
	for item in range(item_list.get_item_count()):
		item_list.set_item_disabled(item, false)




# This function emit a signal
func _on_CorrectTimer_timeout():
	"""
	This function is connected to a timer,
	when the timer arrive to 0 send the signal
	"""
	
	# Send the signal Correct
	emit_signal("Correct")
	
	# Call hideCoponents() function
	hideCoponents()




# This function emit a signal
func _on_WrongTimer_timeout():
	"""
	This function is connected to a timer,
	when the timer arrive to 0 send the signal
	"""
	
	# Send the signal Wrong
	emit_signal("Wrong")
	
	# Call hideCoponents() function
	hideCoponents()

