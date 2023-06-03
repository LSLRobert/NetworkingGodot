extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 1910
var server_id = 1
var is_conneced = false

var username
var password

func _ready():
	pass

func _process(_delta):
	if get_custom_multiplayer() == null: return
	if not custom_multiplayer.has_network_peer(): return
	custom_multiplayer.poll()

func ConnectToServer(_username, _password):
#	network = NetworkedMultiplayerENet.new()
#	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	var err = network.create_client(ip, port)
	if err == OK:
		set_custom_multiplayer(gateway_api)
		custom_multiplayer.set_root_node(self)
		custom_multiplayer.set_network_peer(network)
		print("Login Network Succesfully!")
		network.connect("connection_failed", self, "_OnConnectedFailed")
		network.connect("connection_succeeded", self, "_OnConnectedSucceeded")
	else:
		print_debug("Login Network Failure! Error ", err)

func _OnConnectedFailed():
	is_conneced = false
	#popup
	print("Failed to connect to Login Server")
	get_node("res://Scenes/LoginScreen.tscn").login_button.disabled = false

func _OnConnectedSucceeded():
	is_conneced = true
	print("Succesfully connected to Login Server")
	RequestLogin()

func RequestLogin():
	print("Connecting to gateway to request login")
	rpc_id(server_id, "LoginRequest", username, password)
	username = ""
	password = ""

remote func ReturnLoginRequest(result): 
	print("results recieved")
	if result == true:
		Server.ConnectToServer()
		get_node("res://Scenes/LoginServer.tscn").queue_free()
	else:
		print("Please provide correct username and password!")
		get_node("res://Scenes/LoginServer.tscn").login_button.disabled = false
	network.disconnect("connection_failed", self, "_OnConnectedFailed")
	network.disconnect("connection_succeeded", self, "_OnConnectedSucceeded")
