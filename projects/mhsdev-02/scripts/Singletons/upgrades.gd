extends Node

enum Upgrades {
	SPEED,
	STRENGTH,
	STAMINA,
	THIRST,
	HUNGER
}

func get_upgrade_data(upgrade:Upgrades):
	
	var data = {
		"desc": "Unnamed",
		"icon": "res://images/items/bread.png",
		"lim": 1
	}
	
	match upgrade:
		Upgrades.SPEED:
			data["desc"] = "Increased movement speed"
			#data["icon"] = ""
			data["lim"] = 100
	
	return data
