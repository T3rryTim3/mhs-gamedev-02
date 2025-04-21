extends Node

enum GameDifficulties {
	EASY,
	MEDIUM,
	HARD
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

func set_difficulty():
	pass

func _ready() -> void:
	pass
