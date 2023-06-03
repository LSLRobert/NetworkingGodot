extends Node
#ServerData -> GameData

var skill_data

func _ready():
	var _points_dict = {"White": 50, "Yellow": 75, "Orange": 100}
	# access -> skill_data["Spear"].damage
	skill_data = {
		"Spear": { damage = 86 },
		"Sword": { damage = 75 },
		"Axe":   { damage = 94 }
	}
