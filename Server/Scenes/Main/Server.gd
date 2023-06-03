extends Node

# original tutoril is GDScript 3
# https://www.youtube.com/watch?v=lnFN6YabFKg&list=PLZ-54sd-DMAKU8Neo5KsVmq8KtoDkfi4s
# https://godotengine.org/article/multiplayer-changes-godot-4-0-report-3/

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_player = 100
var peers = []

func _ready():
	StartServer()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		DisconnectAllClients()
		get_tree().quit()

func StartServer():
	var err = network.create_server(port, max_player)
	if err == OK:
		get_tree().set_network_peer(network)
		print("Server started")
		network.connect("peer_connected", self, "_Peer_Connected")
		network.connect("peer_disconnected", self, "_Peer_Disconnected")
	else:
		print_debug("Server Failure! Error ", err)

# player_id is a peer ID
func _Peer_Connected(peer_id):
	peers.push_back(peer_id)
	print("User " + str(peer_id) + " Connected")
	
func _Peer_Disconnected(peer_id):
	peers.remove(peer_id)
	print("User " + str(peer_id) + " Disconnected")

func DisconnectAllClients():
	for peer_id in peers:
		rpc_id(peer_id, "ServerDown")

# Server->Server.gd script, send request to Client->Server.gd
# both sides use same name for clearity
remote func FetchSkillDamage(skill_name, requester):
	var peer_id = get_tree().get_rpc_sender_id()
	var damage = ServerData.skill_data[skill_name].damage
	rpc_id(peer_id, "RetrunSkillDamage", skill_name, damage, requester)
	print("Sending ", str(damage), " to payer")
