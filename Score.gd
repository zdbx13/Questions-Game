extends CanvasLayer


# Define variables
onready var scoreLabel = $CenterContainer/VBoxContainer/HBoxContainer/ScoreLabel

# This function is executed when call the file
func _ready():
	"""
	This function hide the scene 
	"""
	hide()
	 

# This function add the value to the label
func printLabel(score):
	"""
	This funciton recive score value and print them in the label
	"""
	
	# Add score to label value
	scoreLabel.text = str(score)
