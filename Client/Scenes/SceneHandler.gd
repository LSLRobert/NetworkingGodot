extends Node
#SceneHandler
# Loads and Runs scenes as needed

var mapstart = preload("res://Scenes/GameScenes/World/World.tscn")

func _ready():
	var mapstart_instance = mapstart.instance()
	add_child(mapstart_instance)
