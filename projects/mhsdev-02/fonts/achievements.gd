extends Node

signal achievement_gained

enum Achievements {
	STRONGMAN,
	FIELD_STANDARD,
	FIELD_ROWDY,
	FIELD_MAYHEM,
	TUNDRA_STANDARD,
	TUNDRA_ROWDY,
	TUNDRA_MAYHEM,
	DESERT_STANDARD,
	DESERT_ROWDY,
	DESERT_MAYHEM,
	ADDICT,
	ILL_BE_BACK,
	HUNDRED_DEATHS,
	BUILDER,
	BUILDER_2
}

var data = {
	Achievements.STRONGMAN: {
		"name": "Strongman",
		"desc": "Carry three items at once",
		"icon": "res://images/upgrades/Dumb bell.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.FIELD_STANDARD: {
		"name": "Outfarmed",
		"desc": "Beat field on standard mode. Unlocks rowdy mode.",
		"icon": "res://images/Achievements/hat.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.FIELD_ROWDY: {
		"name": "Fielding Rowdy",
		"desc": "Beat field on rowdy mode. Unlocks mayhem mode.",
		"icon": "res://images/Achievements/damaged hat.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.FIELD_MAYHEM: {
		"name": "Absolute Mayhem",
		"desc": "Beat field on mayhem mode.",
		"icon": "res://images/Achievements/Oh goodness.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.TUNDRA_STANDARD: {
		"name": "Rather Cold",
		"desc": "Beat tundra on standard mode. Unlocks rowdy mode.",
		"icon": "res://images/Achievements/cold.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.TUNDRA_ROWDY: {
		"name": "Hypothermia",
		"desc": "Beat tundra on rowdy mode. Unlocks mayhem mode.",
		"icon": "res://images/Achievements/Freezing.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.TUNDRA_MAYHEM: {
		"name": "Absolute Zero",
		"desc": "Beat tundra on mayhem mode.",
		"icon": "res://images/Achievements/0 kelvin.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.DESERT_STANDARD: {
		"name": "The Good",
		"desc": "Beat desert on standard mode. Unlocks rowdy mode.",
		"icon": "res://images/Achievements/pokey plant.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.DESERT_ROWDY: {
		"name": "The bad",
		"desc": "Beat desert on rowdy mode. Unlocks mayhem mode.",
		"icon": "res://images/Achievements/well done pokey plant.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.DESERT_MAYHEM: {
		"name": "The ugly",
		"desc": "Beat desert on mayhem mode.",
		"icon": "res://images/Achievements/Congratulations pokey plant.png",
		"max": 1 # The amount of progress needed for the achievement to complete
	},
	Achievements.ADDICT: {
		"name": "Addict",
		"desc": "Beat the game 10 times.",
		"icon": "res://images/Achievements/Good job.png",
		"max": 10 # The amount of progress needed for the achievement to complete
	},
	Achievements.ILL_BE_BACK: {
		"name": "I'll be back",
		"desc": "Die 10 times.",
		"icon": "res://images/Achievements/Death.png",
		"max": 10 # The amount of progress needed for the achievement to complete
	},
	Achievements.HUNDRED_DEATHS: {
		"name": "'Tis but a scratch",
		"desc": "Die 100 times.",
		"icon": "res://images/Achievements/Frost Burn.png",
		"max": 100 # The amount of progress needed for the achievement to complete
	},
	Achievements.BUILDER: {
		"name": "Builder",
		"desc": "Build 10 stations.",
		"icon": "res://images/Achievements/Stop.png",
		"max": 10 # The amount of progress needed for the achievement to complete
	},
	Achievements.BUILDER_2: {
		"name": "Urban Planning",
		"desc": "Build 100 stations.",
		"icon": "res://images/Achievements/Hammer time.png",
		"max": 100 # The amount of progress needed for the achievement to complete
	}
}

var current = {}

func _ready():
	for k in data.keys():
		current[k] = 0

func raise_progress(achievement:Achievements.Achievements, increase:int=1): ## Increases the progress for a given achievement.
	if not achievement in current:
		current[achievement] = 0
	if has_achievement(achievement):
		return
	current[achievement] = min(data[achievement]["max"], current[achievement] + increase)
	if current[achievement] >= data[achievement]["max"]:
		achievement_gained.emit(achievement)
	#print("Progressed Raised")
	#print(current)
func has_achievement(achievement) -> bool:
	return (current[achievement] and current[achievement] >= data[achievement]["max"])
