extends Node

enum GameDifficulties {
	FIELD_STANDARD,
	MEDIUM,
	HARD,
	PAIN_AND_SUFFERING
}

var PLAYER_BASE_MOVE_SPEED = 100 # Base movement speed
var PLAYER_BASE_ITEM_LIMIT:int = 1 # Base item stacking limit for the player

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

# Upgrades given every machine power
var UPGRADE_COUNT = 3

# Base player stats
var MAX_HUNGER:int = 100
var MAX_THIRST:int = 100
var MAX_STAMINA:int = 100

func get_difficulty_level_data(difficulty: GameDifficulties) -> Level.LevelData:
	match difficulty:
		GameDifficulties.FIELD_STANDARD:
			var data = Level.LevelData.new()
			data.event_cooldown = 60
			data.strength_per_minute = 5
			return data
		GameDifficulties.MEDIUM:
			var data = Level.LevelData.new()
			data.event_cooldown = 30
			data.strength_per_minute = 10
			return data
		GameDifficulties.HARD:
			var data = Level.LevelData.new()
			data.event_cooldown = 15
			data.strength_per_minute = 20
			return data
		GameDifficulties.PAIN_AND_SUFFERING:
			var data = Level.LevelData.new()
			data.event_cooldown = 1
			data.strength_per_minute = 200
			return data
		_:
			return Level.LevelData.new()

func set_difficulty():
	pass

func _ready() -> void:
	pass
