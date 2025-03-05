extends Node

enum GameDifficulties {
	EASY,
	MEDIUM,
	HARD
}

var PLAYER_BASE_MOVE_SPEED = 100 # Base movement speed
var SPEED_TOTEM_INCREASE = 20 # Movement speed gained per speed totem
var HIGH_TEMP_SPEED_FACTOR = 0 # Movement speed decreased when overheating
var LOW_TEMP_SPEED_FACTOR = 30 # Movement speed decreased when too cold
var HIGH_TEMP_THRESHOLD = 0.9 # Threshold for overheating
var LOW_TEMP_THRESHOLD = 0.1 # Threshold for freezing

func set_difficulty():
	pass

func _ready() -> void:
	pass
