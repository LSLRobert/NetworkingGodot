extends Node
#Autentication

var network = NetworkedMultiplayerENet.new()
var port = 1911
var max_servers = 5
var gateways = []

func _ready():
	StartServer()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		DisconnectAllClients()
		get_tree().quit()

func StartServer():
	var err = network.create_server(port, max_servers)
	if err == OK:
		get_tree().set_network_peer(network)
		print("Authentication srver started")
		network.connect("peer_connected", self, "_Peer_Connected")
		network.connect("peer_disconnected", self, "_Peer_Disconnected")
	else:
		print_debug("Authentication Server Failure! Error ", err)

# player_id is a peer ID
func _Peer_Connected(gateway_id):
	gateways.push_back(gateway_id)
	print("Gateway " + str(gateway_id) + " Connected")

func _Peer_Disconnected(gateway_id):
	gateways.remove(gateway_id)
	print("Gateway " + str(gateway_id) + " Disconnected")

func DisconnectAllClients():
	for gateway_id in gateways:
		rpc_id(gateway_id, "ServerDown")

remote func AuthenticatePlayer(username, password, peer_id):
	print("authentication request received")
	var gateway_id = get_tree().get_rpc_sender_id()
	var result = false
	print("Starting authentication")
	if not PlayerData.username == username:
#	if not PlayerData.PlayerIDs.has(username):
		print("User not recognized")
		result = false
	elif not PlayerData.password == password:
#	elif not PlayerData.PlayerIDs[username].password == password:
		print("Incorrect password")
		result = false
	else:
		print("Succesful authentication")
		result = true
	print("authentication result send to gateway server")
	rpc_id(gateway_id, "AuthenticationResults", result, peer_id)
