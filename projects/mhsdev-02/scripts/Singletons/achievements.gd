extends Node

enum Achievements {
	STRONGMAN,
	FIELD_STANDARD,
	FIELD_ROWDY,
	FIELD_MAYHEM,
	ADDICT
}

var data = {
	Achievements.STRONGMAN: {
		"name": "Strongman",
		"desc": "Carry three items at once",
		"icon": "res://images/items/bread.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.FIELD_STANDARD: {
		"name": "Fielding standard",
		"desc": "Beat field on standard mode. Unlocks rowdy mode.",
		"icon": "res://images/items/bread.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.FIELD_ROWDY: {
		"name": "Fielding Rowdy",
		"desc": "Beat field on rowdy mode. Unlocks mayhem mode.",
		"icon": "res://images/items/bread.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.FIELD_MAYHEM: {
		"name": "Absolute Mayhem",
		"desc": "Beat field on mayhem mode.",
		"icon": "res://images/items/bread.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.ADDICT: {
		"name": "Addict",
		"desc": "Beat the game 10 times",
		"icon": "res://images/items/bread.png",
		"max": 10 # The amount of progress needed for the achievement to complete
	}
}

var current = {}

func _ready():
	print("achievements Singleton Initialized")
	for k in data.keys():
		current[k] = 0

func raise_progress(achievement:Achievements.Achievements, increase:int=1): ## Increases the progress for a given achievement.
	if not achievement in current:
		current[achievement] = 0
	current[achievement] = min(data[achievement]["max"], current[achievement] + increase)

func get_data():
	return data
