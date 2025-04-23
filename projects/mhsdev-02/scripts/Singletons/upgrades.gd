extends Node

enum Upgrades {
	SPEED,
	STRENGTH,
	STAMINA,
	THIRST,
	HUNGER,
	TOUGH
}

func get_upgrades() -> Array[Upgrades.Upgrades]: ## Returns an array of all of the upgrades
	return [
		Upgrades.SPEED,
		Upgrades.STRENGTH,
		Upgrades.STAMINA,
		Upgrades.THIRST,
		Upgrades.HUNGER,
		Upgrades.TOUGH
	]

func get_upgrade_data(upgrade:Upgrades.Upgrades):
	
	var data = {
		"desc": "Unnamed",
		"icon": "res://images/items/bread.png",
		"lim": 100
	}
	
	match upgrade:
		Upgrades.SPEED:
			data["desc"] = "Increased movement speed"
			#data["icon"] = ""
			data["lim"] = 100
		Upgrades.STRENGTH:
			data["desc"] = "+1 Item carry limit"
			data["lim"] = 5
		Upgrades.STAMINA:
			data["desc"] = "Use 20% less stamina when sprinting"
		Upgrades.THIRST:
			data["icon"] = "res://images/items/water.png"
			data["desc"] = "Higher max thirst"
		Upgrades.HUNGER:
			data["desc"] = "Higher max hunger"
		Upgrades.TOUGH:
			data["desc"] = "You take 15% less damage."
			data["lim"] = 5
	
	return data
