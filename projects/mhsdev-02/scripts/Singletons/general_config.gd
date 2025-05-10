extends Node

enum GameDifficulties {
	TUTORIAL,
	FIELD_STANDARD,
	FIELD_ROWDY,
	FIELD_MAYHEM,
	FIELD_ENDLESS,
	TUNDRA_STANDARD,
	TUNDRA_ROWDY,
	TUNDRA_MAYHEM,
	TUNDRA_ENDLESS,
	DESERT_STANDARD,
	DESERT_ROWDY,
	DESERT_MAYHEM,
	DESERT_ENDLESS,
	CUSTOM
}

var levels = [
	{
		"name": "Tutorial",
		"description": "Learn the basics.",
		"color": Color(0.9,0.9,0.9),
		"text_color": Color(0,0,0),
		"bg_color":Color(1,1,1),
		"scene_enum": Main.Scenes.LEVEL_TUTORIAL,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Tutorial",
				"leveldata": Config.GameDifficulties.TUTORIAL,
				"bg_color": Color(0,0,0),
				"text_color": Color("ffffff"),
				"image": "res://images/UI/Thumbnail/tutorial.png",
				"desc": [
					["None", Color(0.4,1,0.4)]
				]
			}
		]
	},
	{
		"name": "Field",
		"description": "An empty field perfect for farming.",
		"music_path": "res://Audio/Music/Field.mp3",
		"color": Color(0,1,0),
		"text_color": Color("004516"),
		"bg_color":Color(0.108,0.5,0),
		"scene_enum": Main.Scenes.LEVEL_FIELD,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.FIELD_STANDARD,
				#"color" : Color(0.4, 1, 0.4),
				"bg_color":Color(0.799,0.948,0.716),
				"text_color": Color("a8f6b1"),
				"image": "res://images/UI/Thumbnail/field_standard.png",
				"desc": [
					["55s Event delay", Color(1,0,0)],
					["-0.4 Temperature", Color(1,0,0)]
				]
				
			},
			{
				"name": "Rowdy",
				"achievement": Achievements.Achievements.FIELD_STANDARD,
				"leveldata": Config.GameDifficulties.FIELD_ROWDY,
				#"color" : Color(1, 1, 0.4),
				"bg_color": Color("f1ea6d"),
				"text_color": Color("8df799"),
				"image": "res://images/UI/Thumbnail/field_rowdy.png",
				"desc": [
					["-10s between events", Color(1,0,0)],
					["Hunger decreases faster", Color(1,0,0)],
					["Thirst decreases faster", Color(1,0,0)],
					["Events are stronger", Color(1,0,0)]
				]
			},
			{
				"name": "Mayhem",
				"achievement": Achievements.Achievements.FIELD_ROWDY,
				"leveldata": Config.GameDifficulties.FIELD_MAYHEM,
				#"color" : Color(1, 0.4, 0.4),
				"bg_color": Color("ec4e00"),
				"text_color": Color("7cf78a"),
				"image": "res://images/UI/Thumbnail/field_mayhem.png",
				"desc": [
					["All events are doubled", Color(1,0,0)],
					["Temperature drains twice as fast", Color(1,0,0)]
				]
			}
		]
	},
	{
		"name": "Tundra",
		"description": "A harsh environment requiring a good source of heat and food.",
		"music_path": "res://Audio/Music/frost-final.mp3",
		"color": Color(1,1,1),
		"text_color": Color("310095"),
		"bg_color": Color("f1f3ff"),
		"scene_enum": Main.Scenes.LEVEL_TUNDRA,
		"achievement": Achievements.Achievements.FIELD_STANDARD,
		"image_path": "res://images/placeholder/Screenshot from 2025-05-01 20-43-53.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.TUNDRA_STANDARD,
				#"color" : Color("00f0fc"),
				"bg_color":Color("00f0fc"),
				"image": "res://images/UI/Thumbnail/tundra_standard.png",
				"text_color": Color("c7e0ff"),
				"desc": [
					["60s Event delay", Color(1,0,0)],
					["-1.2 Temperature", Color(1,0,0)],
					["Hunger drains slower", Color(0,1,0)],
					["Thirst drains slower", Color(0,1,0)]
				]
				
			},
			{
				"name": "Rowdy",
				"leveldata": Config.GameDifficulties.TUNDRA_ROWDY,
				#"color" : Color("ea00c0"),
				"bg_color": Color("ea00c0"),
				"text_color": Color("a7cfff"),
				"image": "res://images/UI/Thumbnail/tundra_rowdy.png",
				"desc": [
					["-10s between events", Color(1,0,0)],
					["Hunger decreases faster", Color(1,0,0)],
					["Thirst decreases faster", Color(1,0,0)],
					["Events are stronger", Color(1,0,0)]
				]
			},
			{
				"name": "Mayhem",
				"leveldata": Config.GameDifficulties.TUNDRA_MAYHEM,
				#"color" : Color("fa0008"),
				"bg_color": Color("73b2ff"),
				"text_color": Color("a7cfff"),
				"image": "res://images/UI/Thumbnail/tundra_mayhem.png",
				"desc": [
					["All events are doubled", Color(1,0,0)],
					["Temperature drains twice as fast", Color(1,0,0)]
				]
			}
		]
	},
	{
		"name": "Desert",
		"description": "A dry, unforgiving environment with more disasters.",
		"music_path": "res://Audio/Music/Desert-final.wav",
		"color": Color(1,0.9,0),
		"bg_color": Color("fcfa6f"),
		"text_color": Color("483000"),
		"scene_enum": Main.Scenes.LEVEL_DESERT,
		"achievement": Achievements.Achievements.TUNDRA_STANDARD,
		"image_path": "res://images/placeholder/Screenshot from 2025-05-01 20-43-53.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.TUNDRA_STANDARD,
				"bg_color": Color("fa8900"),
				"image": "res://images/UI/Thumbnail/desert_standard.png",
				"text_color": Color("ede4b9"),
				"desc": [
					["60s Event delay", Color(1,0,0)],
					["-1.2 Temperature", Color(1,0,0)],
					["Hunger drains slower", Color(0,1,0)],
					["Thirst drains slower", Color(0,1,0)]
				]
				
			},
			{
				"name": "Rowdy",
				"leveldata": Config.GameDifficulties.TUNDRA_ROWDY,
				"bg_color": Color("a66cf6"),
				"image": "res://images/UI/Thumbnail/desert_rowdy.png",
				"text_color": Color("ede1a8"),
				"desc": [
					["-10s between events", Color(1,0,0)],
					["Hunger decreases faster", Color(1,0,0)],
					["Thirst decreases faster", Color(1,0,0)],
					["Events are stronger", Color(1,0,0)]
				]
			},
			{
				"name": "Mayhem",
				"leveldata": Config.GameDifficulties.TUNDRA_MAYHEM,
				"bg_color": Color("ff384d"),
				"image": "res://images/UI/Thumbnail/desert_mayhem.png",
				"text_color": Color("eddb80"),
				"desc": [
					["All events are doubled", Color(1,0,0)],
					["Temperature drains twice as fast", Color(1,0,0)]
				]
			}
		]
	},
	{
		"name": "Custom",
		"description": "A sandbox to play as you wish",
		"color": Color(1,0,1),
		"scene_enum": null,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Custom",
				"leveldata": Config.GameDifficulties.TUTORIAL,
				"image": "res://images/UI/Thumbnail/custom.png",
				"desc": [
					["x2 Events", Color(1,0,0)],
					["x2 Events", Color(1,0,0)]
				]
			}
		]
		
	}
]

var PLAYER_BASE_MOVE_SPEED = 115 # Base movement speed
var PLAYER_BASE_ITEM_LIMIT:int = 2 # Base item stacking limit for the player

var SPEED_TOTEM_INCREASE = 20 # Movement speed gained per speed totem
var HIGH_TEMP_SPEED_FACTOR = 0 # Movement speed decreased when overheating
var LOW_TEMP_SPEED_FACTOR = 30 # Movement speed decreased when too cold
var HIGH_TEMP_THRESHOLD = 0.9 # Threshold for overheating
var LOW_TEMP_THRESHOLD = 0.1 # Threshold for freezing
var THIRST_STAMINA_THRESHHOLD = 1 # Minimum thirst to gain stamina

# Stat increases for the upgrades
var SPEED_UPGRADE_INCREASE = 15
var HUNGER_UPGRADE_INCREASE = 20
var THIRST_UPGRADE_INCREASE = 20
var STAMINA_UPGRADE_INCREASE = 20

# Stat drain stats
var DRAIN_HUNGER:float = 0.26
var DRAIN_THIRST:float = 0.46

# Upgrades given every machine power
var UPGRADE_COUNT = 3

# Base player stats
var MAX_HUNGER:int = 100
var MAX_THIRST:int = 100
var MAX_STAMINA:int = 100

func get_difficulty_level_data(difficulty: GameDifficulties) -> Level.LevelData:
	var data:Level.LevelData = Level.LevelData.new()
	match difficulty:
		GameDifficulties.TUTORIAL:
			data = Level.LevelData.new()
			data.event_cooldown = 100000
			data.item_spawn_cooldown = 2.5
			data.temp_drain = 0
			data.strength_per_minute = 0.1
			data.thirst_multi = 0.5
			data.hunger_multi = 0.5

		#Field Settings

		GameDifficulties.FIELD_STANDARD:
			data = Level.LevelData.new()
			data.event_cooldown = 55
			data.strength_per_minute = 0.4
			data.temp_drain = 0.4
			return data
		
		GameDifficulties.FIELD_ROWDY:
			data = Level.LevelData.new()
			data.event_cooldown = 45
			data.temp_drain = 0.4
			data.strength_per_minute = 0.6
			data.thirst_multi = 1.2
			data.hunger_multi = 1.2
		
		GameDifficulties.FIELD_MAYHEM:
			data.event_cooldown = 45
			data.grace_period = 0
			data.temp_drain = 0.8
			data.event_multiplier = 2
			data.strength_per_minute = 1.2
			data.thirst_multi = 1.5
			data.hunger_multi = 1.5
		
		GameDifficulties.FIELD_ENDLESS:
			data.event_cooldown = 55
			data.strength_per_minute = 1.2
			data.temp_drain = 0.4
			return data
		
		#Tundra Settings
		
		GameDifficulties.TUNDRA_STANDARD:
			data.event_cooldown = 60
			data.strength_per_minute = 0.4
			data.temp_drain = 1.2
			data.thirst_multi = 0.8
			data.hunger_multi = 0.8
			data.events.append(EventMan.Events.BLIZZARD)
			return data
		
		GameDifficulties.TUNDRA_ROWDY:
			data.event_cooldown = 50
			data.temp_drain = 1.6
			data.thirst_multi = 1.5
			data.strength_per_minute = 0.8
			data.hunger_multi = 1
			data.events.append(EventMan.Events.BLIZZARD)
			return data
		
		GameDifficulties.TUNDRA_MAYHEM:
			data.event_cooldown = 40
			data.temp_drain = 2
			data.grace_period = 0
			data.thirst_multi = 1.5
			data.strength_per_minute = 1
			data.hunger_multi = 1.25
			data.events.append(EventMan.Events.BLIZZARD)
			return data
		
		GameDifficulties.TUNDRA_ENDLESS:
			data.event_cooldown = 60
			data.temp_drain = 1.2
			data.thirst_multi = 1.25
			data.strength_per_minute = 1.2
			data.hunger_multi = 0.8
			data.events.append(EventMan.Events.BLIZZARD)
			return data
			
		GameDifficulties.DESERT_STANDARD:
			data.event_cooldown = 40
			data.grace_period = 40
			data.temp_drain = 0
			data.thirst_multi = 1.6
			data.strength_per_minute = 1
			data.hunger_multi = 0.9
			#data.events.append(EventMan.Events.SANDSTORM)
			return data
			
		GameDifficulties.DESERT_ROWDY:
			data.event_cooldown = 30
			data.grace_period = 25
			data.temp_drain = 0.5
			data.thirst_multi = 2.2
			data.event_multiplier = 2
			data.strength_per_minute = 0.8
			data.hunger_multi = 1
			#data.events.append(EventMan.Events.SANDSTORM)
			return data
			
		GameDifficulties.DESERT_MAYHEM:
			data.event_cooldown = 25
			data.grace_period = 15
			data.temp_drain = 1
			data.grace_period = 0
			data.thirst_multi = 2
			data.strength_per_minute = 0.6
			data.hunger_multi = 0.314159265
			data.event_multiplier = 3
			#data.events.append(EventMan.Events.SANDSTORM)
			return data
			
		GameDifficulties.DESERT_ENDLESS:
			data.event_cooldown = 30
			data.temp_drain = -3
			data.thirst_multi = 1.8
			data.strength_per_minute = 1.25
			data.hunger_multi = 0.25
			data.event_multiplier = 2
			#data.events.append(EventMan.Events.SANDSTORM)
			return data
		
		
		GameDifficulties.CUSTOM:
			var sliders_root = get_node("/root/select/CustomSliders")
			data.event_cooldown = sliders_root.get_node("Cooldown").value
			data.item_spawn_cooldown = sliders_root.get_node("ItemSpawn").value
			data.temp_drain = sliders_root.get_node("Temperature").value
			data.strength_per_minute = sliders_root.get_node("Events").value
			data.thirst_multi = sliders_root.get_node("Thirst").value
			data.hunger_multi = sliders_root.get_node("Hunger").value
			data.events.append(EventMan.Events.BLIZZARD)
		_:
			return Level.LevelData.new()
	data.mode = difficulty
	return data
func set_difficulty():
	pass

func _ready() -> void:
	pass
