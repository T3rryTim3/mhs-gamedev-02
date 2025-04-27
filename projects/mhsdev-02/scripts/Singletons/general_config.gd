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
	CUSTOM
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
var DRAIN_HUNGER:float = 0.33
var DRAIN_THIRST:float = 0.46

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
			data.item_spawn_cooldown = 2.5
			data.temp_drain = 0
			data.strength_per_minute = 0.1
			data.thirst_multi = 0.5
			data.hunger_multi = 0.5
			
			return data
		
		#Field Settings
		
		GameDifficulties.FIELD_STANDARD:
			var data = Level.LevelData.new()
			data.event_cooldown = 55
			data.temp_drain = 0.4
			return data
		
		GameDifficulties.FIELD_ROWDY:
			var data = Level.LevelData.new()
			data.event_cooldown = 45
			data.temp_drain = 0.4
			data.strength_per_minute = 1.5
			data.event_multiplier = 2
			data.thirst_multi = 1.2
			data.hunger_multi = 1.2
			return data
		
		GameDifficulties.FIELD_MAYHEM:
			var data = Level.LevelData.new()
			data.event_cooldown = 35
			data.temp_drain = 0.8
			data.strength_per_minute = 1.5
			data.thirst_multi = 1.5
			data.hunger_multi = 1.5
			return data
		
		GameDifficulties.FIELD_ENDLESS:
			var data = Level.LevelData.new()
			data.event_cooldown = 55
			data.temp_drain = 0.4
			return data
		
		#Tundra Settings
		
		GameDifficulties.TUNDRA_STANDARD:
			var data = Level.LevelData.new()
			data.event_cooldown = 60
			data.temp_drain = 1.2
			data.thirst_multi = 1.25
			data.hunger_multi = 0.8
			return data
		
		GameDifficulties.TUNDRA_ROWDY:
			var data = Level.LevelData.new()
			data.event_cooldown = 50
			data.temp_drain = 1.6
			data.thirst_multi = 1.5
			data.hunger_multi = 1
			return data
		
		GameDifficulties.TUNDRA_MAYHEM:
			var data = Level.LevelData.new()
			data.event_cooldown = 40
			data.temp_drain = 2
			data.thirst_multi = 1.5
			data.hunger_multi = 1.25
			return data
		
		GameDifficulties.TUNDRA_ENDLESS:
			var data = Level.LevelData.new()
			data.event_cooldown = 60
			data.temp_drain = 1.2
			data.thirst_multi = 1.25
			data.hunger_multi = 0.8
			return data
			
		GameDifficulties.CUSTOM:
			var data = Level.LevelData.new()
			var sliders_root = get_node("/root/select/CustomSliders")
			data.event_cooldown = sliders_root.get_node("Cooldown").value
			data.item_spawn_cooldown = sliders_root.get_node("ItemSpawn").value
			data.temp_drain = sliders_root.get_node("Temperature").value
			data.strength_per_minute = sliders_root.get_node("Events").value
			data.thirst_multi = sliders_root.get_node("Thirst").value
			data.hunger_multi = sliders_root.get_node("Hunger").value
	
			return data
			
			
			
		_:
			return Level.LevelData.new()

func set_difficulty():
	pass

func _ready() -> void:
	pass
