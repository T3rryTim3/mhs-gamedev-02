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
	TUNDRA_ENDLESS
}

var PLAYER_BASE_MOVE_SPEED = 100 # Base movement speed
var PLAYER_BASE_ITEM_LIMIT:int = 2 # Base item stacking limit for the player

var SPEED_TOTEM_INCREASE = 20 # Movement speed gained per speed totem
var HIGH_TEMP_SPEED_FACTOR = 0 # Movement speed decreased when overheating
var LOW_TEMP_SPEED_FACTOR = 30 # Movement speed decreased when too cold
var HIGH_TEMP_THRESHOLD = 0.9 # Threshold for overheating
var LOW_TEMP_THRESHOLD = 0.1 # Threshold for freezing
var THIRST_STAMINA_THRESHHOLD = 1 # Minimum thirst to gain stamina

# Stat increases for the upgrades
var SPEED_UPGRADE_INCREASE = 20
var HUNGER_UPGRADE_INCREASE = 20
var THIRST_UPGRADE_INCREASE = 20
var STAMINA_UPGRADE_INCREASE = 20

# Stat drain stats
var DRAIN_HUNGER:float = 0.45
var DRAIN_THIRST:float = 0.6

# Upgrades given every machine power
var UPGRADE_COUNT = 3

# Base player stats
var MAX_HUNGER:int = 100
var MAX_THIRST:int = 100
var MAX_STAMINA:int = 100

func get_difficulty_level_data(difficulty: GameDifficulties) -> Level.LevelData:
	match difficulty:
		GameDifficulties.TUTORIAL:
			var data = Level.LevelData.new()
			data.event_cooldown = 100000
			#data.temperature = 0
			return data
		
		#Field Settings
		
		GameDifficulties.FIELD_STANDARD:
			var data = Level.LevelData.new()
			data.event_cooldown = 55
			#data.temperature = -1
			return data
		
		GameDifficulties.FIELD_ROWDY:
			var data = Level.LevelData.new()
			data.event_cooldown = 45
			#data.temperature = -1
			data.events = 1.5
			data.thirst_multi = 1.2
			data.hunger_multi = 1.2
			return data
		
		GameDifficulties.FIELD_MAYHEM:
			var data = Level.LevelData.new()
			data.event_cooldown = 35
			#data.temperature = -2
			data.events = 1.5
			data.thirst_multi = 1.5
			data.hunger_multi = 1.5
			return data
		
		GameDifficulties.FIELD_ENDLESS:
			var data = Level.LevelData.new()
			data.event_cooldown = 55
			#data.temperature = -1
			return data
		
		#Tundra Settings
		
		GameDifficulties.TUNDRA_STANDARD:
			var data = Level.LevelData.new()
			data.event_cooldown = 60
			#data.temperature = -3
			data.thirst_multi = 1.25
			data.hunger_multi = 0.8
			return data
		
		GameDifficulties.TUNDRA_ROWDY:
			var data = Level.LevelData.new()
			data.event_cooldown = 50
			#data.temperature = -4
			data.thirst_multi = 1.5
			data.hunger = 1
			return data
		
		GameDifficulties.TUNDRA_MAYHEM:
			var data = Level.LevelData.new()
			data.event_cooldown = 40
			#data.temperature = -5
			data.thirst_multi = 1.5
			data.hunger_multi = 1.25
			return data
		
		GameDifficulties.TUNDRA_ENDLESS:
			var data = Level.LevelData.new()
			data.event_cooldown = 60
			#data.temperature = -3
			data.thirst_multi = 1.25
			data.hunger_multi = 0.8
			return data
		_:
			return Level.LevelData.new()

func set_difficulty():
	pass

func _ready() -> void:
	pass
