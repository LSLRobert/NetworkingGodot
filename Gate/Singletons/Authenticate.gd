extends Node
#Gateway

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1911
var server_id = 1
var is_conneced = false

func _ready():
	ConnectToServer()

func ConnectToServer():
	var err = network.create_client(ip, port)
	if err == OK:
		get_tree().set_network_peer(network)
		print("Gateway Succesfully!")
		network.connect("connection_failed", self, "_OnConnectedFailed")
		network.connect("connection_succeeded", self, "_OnConnectedSucceeded")
	else:
		print_debug("Gateway Failure! Error ", err)

func _OnConnectedFailed():
	is_conneced = false
	print("Failed to connect")

func _OnConnectedSucceeded():
	is_conneced = true
	print("Succesfully connected")

func AuthenticatePlayer(username, password, peer_id):
	print("sending out authentication request")
	rpc_id(server_id, "AuthenticatePlayer", username, password, peer_id)

remote func AuthenticationResults(result, peer_id):
	print("sending back authentication result: ", result, " to ", peer_id)
	rpc_id(peer_id, "ReturnLoginRequest", result)
