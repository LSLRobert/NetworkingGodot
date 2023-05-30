extends Node

# original tutoril is GDScript 3
# https://www.youtube.com/watch?v=lnFN6YabFKg&list=PLZ-54sd-DMAKU8Neo5KsVmq8KtoDkfi4s
# https://godotengine.org/article/multiplayer-changes-godot-4-0-report-3/

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_player = 100

func _ready():
	StartServer()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func StartServer():
	network.create_server(port, max_player)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")

# player_id is a peer ID
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " Connected")
	
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " Disconnected")
