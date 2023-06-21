extends Node

# Export the JsonData to send them in an other file
signal request_finished(JsonData)

# Define global variable
var id_list = []
var http_request_in_progress = false


# This function recieves the request data, parses the data, and sends it with a signal
func _on_request_completed(_result, _response_code, _headers, body):
	""" 
	This function receives result, response_code, headers, and body.
	We extract the body content, parse it to format the data,
	and finally emit a signal containing the parsed data.
	"""
	
	# Parse data and save it in a variable
	var json = JSON.parse(body.get_string_from_utf8())
	
	# Select the quiz object
	var JsonData = json.result.quiz
	
	
	# Reset the request in progress flag
	http_request_in_progress = false
	
	# Save the data in the request_finished signal
	emit_signal("request_finished", JsonData)
	


# This function makes a request to get the quiz from DB. 
func make_request():
	"""
	This function is connected to the hit signal from Player.gd.
	When the player is hit, it makes a new request.
	"""
	
	if http_request_in_progress:

		# Request is already in progress, so exit
		$HTTPRequest.cancel_request()
		
	else:

		# Make a request
		$HTTPRequest.request("http://188.34.153.93/api/games/first")
		
		# Set the request in progress flag
		http_request_in_progress = true

		if not $HTTPRequest.is_connected("request_completed", self, "_on_request_completed"):
			$HTTPRequest.connect("request_completed", self, "_on_request_completed")



# This function sends data to the server, to store the puntuation in the ranking.
func sendData(data):
	"""
	This function send score to the server.
	
	Example:
	{"puntuation":"30", "user_id":1, "topic_id":2}
	"""

	# Save path in a variable
	var http_request = $PostHTTPRequest
	
	# Parse data
	var body = JSON.print(data)
	
	# Define headers
	var headers = ["Content-Type: application/json"]
	
	# Make a request
	var _data = http_request.request("http://188.34.153.93/api/games/puntuations", headers, true, HTTPClient.METHOD_POST, body)
	

