extends Node

enum Upgrades {
	SPEED,
	STRENGTH,
	STAMINA,
	THIRST,
	HUNGER
}

func get_upgrades() -> Array[Upgrades.Upgrades]: ## Returns an array of all of the upgrades
	return [
		Upgrades.SPEED,
		Upgrades.STRENGTH,
		Upgrades.STAMINA,
		Upgrades.THIRST,
		Upgrades.HUNGER
	]

func get_upgrade_data(upgrade:Upgrades.Upgrades):
	
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
