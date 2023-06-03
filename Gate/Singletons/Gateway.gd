extends Node
#login

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1910
var max_player = 100
var peers = []

func _ready():
	StartServer()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		DisconnectAllClients()
		get_tree().quit()

func _process(_delta):
	if not custom_multiplayer.has_network_peer(): return
	custom_multiplayer.poll()

func StartServer():
	var err = network.create_server(port, max_player)
	if err == OK:
		set_custom_multiplayer(gateway_api)
		custom_multiplayer.set_root_node(self)
		custom_multiplayer.set_network_peer(network)
		print("Auth Gate started")
		network.connect("peer_connected", self, "_Peer_Connected")
		network.connect("peer_disconnected", self, "_Peer_Disconnected")
	else:
		print_debug("Server Failure! Error ", err)

# player_id is a peer ID
func _Peer_Connected(peer_id):
	peers.push_back(peer_id)
	print("User " + str(peer_id) + " Connected")
	
func _Peer_Disconnected(peer_id):
	peers.remove(peers.find(peer_id))
	print("User " + str(peer_id) + " Disconnected")

func DisconnectAllClients():
	for peer_id in peers:
		rpc_id(peer_id, "ServerDown")

# Server->Server.gd script, send request to Client->Server.gd
# both sides use same name for clearity
remote func LoginRequest(username, password):
	var peer_id = custom_multiplayer.get_rpc_sender_id()
	print("login request received, id: ", peer_id)
	Authenticate.AuthenticatePlayer(username, password, peer_id)
