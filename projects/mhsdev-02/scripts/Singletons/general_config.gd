extends Node

enum GameDifficulties {
	EASY,
	MEDIUM,
	HARD
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
		GameDifficulties.EASY:
			var data = Level.LevelData.new()
			data.event_cooldown_multi = 1
			data.event_strength_multi = 0.5
			
			return data
		GameDifficulties.MEDIUM:
			return Level.LevelData.new()
		GameDifficulties.HARD:
			return Level.LevelData.new()
		_:
			return Level.LevelData.new()

func set_difficulty():
	pass

func _ready() -> void:
	pass
