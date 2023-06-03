extends Node
#Server

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909
var server_id = 1
var is_conneced = false

func _ready():
	pass
#	ConnectToServer()

func ConnectToServer():
	var err = network.create_client(ip, port)
	if err == OK:
		print("Network Succesfully!")
		get_tree().set_network_peer(network)
		network.connect("connection_failed", self, "_OnConnectedFailed")
		network.connect("connection_succeeded", self, "_OnConnectedSucceeded")
	else:
		print_debug("Network Failure! Error ", err)

func _OnConnectedFailed():
	is_conneced = false
	print("Failed to connect")

func _OnConnectedSucceeded():
	is_conneced = true
	print("Succesfully connected")

# Client->Server.gd script, send request to Server->Server.gd
# both sides use same name for clearity
remote func ServerDown():
	print("Server has gone Down!!!")

func FetchSkillDamage(skill_name, requester):
	if !is_conneced: return
	rpc_id(server_id, "FetchSkillDamage", skill_name, requester)

remote func RetrunSkillDamage(skill_name, s_damage, requester):
	print("ID: ", requester, " - ", skill_name, ": ", s_damage)
#	instance_from_id(requester).SetDamage(s_damage)

