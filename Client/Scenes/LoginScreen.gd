extends Control

onready var username_input = get_node("NinePatchRect/VBoxContainer/Username")
onready var password_input = get_node("NinePatchRect/VBoxContainer/Password")
onready var login_button = get_node("NinePatchRect/VBoxContainer/LoginButton")

func _ready():
	pass

func _on_LoginButton_pressed():
	if username_input.text == "" or password_input.text == "":
		#popup and stop
		print("Please provide a valid Username and Password")
	else:
		login_button.disabled = true
		var username = username_input.get_text()
		var password = password_input.get_text()
		print("attempting to login")
		Gateway.ConnectToServer(username, password)


func _on_RegisterButton_pressed():
	pass # Replace with function body.
