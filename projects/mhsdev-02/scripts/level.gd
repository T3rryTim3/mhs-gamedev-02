extends Node2D
class_name Level

signal station_built
signal station_deleted
signal machine_powered
signal victory

## Scene for creating new items
@onready var item_scn = preload("res://scenes/Base/item.tscn")

## Scene for creating UI
@onready var ui_layer_scn = preload("res://scenes/UI/game_ui.tscn")

## Limit for the map (just a collisionshape2d)
@export var map_limit:CollisionShape2D

## The Machine
@export var machine:Machine

## Breakable TileMapLayer
@export var break_layer:TileMapLayer

@export var world_env:WorldEnvironment

## Spawn cooldown for items
var spawn_cooldown:float = 3

## Stress increase per minute.
var strength_increase:float = 1

## Node which handles modulation for the storm
var storm_modulate_node:CanvasModulate

var spawn_items:Dictionary[ItemData.ItemTypes, int] = {
	ItemData.ItemTypes.WHEAT: 10,
}

var events:Array[EventMan.Events]

## If the current level is the tutorial
var tutorial:bool = false

# Seconds between each event
var event_spawn_cooldown:float = 10

# Cooldown for next item spawn
var current_spawn_cooldown:float = 0

## Location to store items
var items:Node

## Location to store stations
var stations:Node

## The map
var map:Node2D

## Its the player.. what else?
var player:Player

## Canvaslayer with ui elements
var ui_layer:CanvasLayer

## Strength of spawned weather events.
var strength:float = 0.0

## Current cooldown before event spawning
var current_event_cooldown:float = 0

## Difficulty settings for the level.
var level_data:LevelData

## If the level is fully loaded
var loaded:bool = false

## Health vignette
@onready var vignette_shader = load("res://Shaders/health_vignette.tres")

## Holds data for level settings. This is used for both preset difficulties and custom ones.
class LevelData:
	var mode : Config.GameDifficulties
	var event_cooldown : float = 45 
	var strength_per_minute : float = 1 
	var damage_multi : float = 1
	var thirst_multi : float = 1 
	var hunger_multi : float = 1 
	var station_health_multi : float = 1
	var item_spawn_cooldown : float = 2.45
	var station_speed_multi : float = 1
	var grace_period : float = 60 # Extra time until the first event
	var temp_drain : float = 0.3
	var item_limit : int = 30 # Max amount of items in the level+6
	var event_multiplier : int = 1
	var events : Array[EventMan.Events] = [
		EventMan.Events.TORNADO,
		EventMan.Events.VOLCANO,
		EventMan.Events.STORM,
		EventMan.Events.EARTHQUAKE
	]
	var items : Dictionary[ItemData.ItemTypes, int] = {
		ItemData.ItemTypes.WHEAT:2,
		ItemData.ItemTypes.ROCK:6,
		ItemData.ItemTypes.WHEAT_SEEDS:12,
		ItemData.ItemTypes.ACORN:10
	}

	func _init() -> void:
		pass

func reload_environment():
	if not world_env:
		return
	world_env.environment.glow_enabled = GameSettings.glow
	print(GameSettings.glow)


func _ready():
	reload_environment()
	Globals.level = self
	Gamestats.initialize()
	ready.connect(func (): loaded=true) # Set loaded to true when fully ready
	if not level_data:
		level_data = LevelData.new() # Default settings

	storm_modulate_node = load("res://scenes/storm_modulate.tscn").instantiate()
	storm_modulate_node.goal = Color(1, 1, 1, 1)
	add_child(storm_modulate_node)
	storm_modulate_node.enabled = true

	# Ensure parent nodes are present, and if not, create them.
	if find_child("Stations") and $Stations is Node:
		stations = $Stations
	else:
		stations = Node.new()
		add_child(stations)

	if find_child("Items") and $Items is Node:
		items = $Items
	else:
		items = Node.new()
		add_child(items)

	if find_child("Map") and $Map is Node2D:
		map = $Map
	else:
		map = Node2D.new()
		add_child(map)

	player = Globals.player
	if not player:
		print("WARNING: PLAYER NOT FOUND")
	
	# Create ui
	ui_layer = ui_layer_scn.instantiate()
	add_child(ui_layer)

	# Connect updates for station effects
	stations.child_order_changed.connect(update_station_stats)
	if machine:
		machine.game_end.connect(_win)
	else:
		print("No machine found.")

	# Load level data
	spawn_cooldown = level_data.item_spawn_cooldown
	current_event_cooldown -= level_data.grace_period
	event_spawn_cooldown = level_data.event_cooldown
	strength_increase = level_data.strength_per_minute
	events = level_data.events
	spawn_items = level_data.items

func _win(): ## Ends the game in a victory
	if (level_data.mode != Config.GameDifficulties.TUTORIAL):
		Achievements.raise_progress(Achievements.Achievements.ADDICT)
	match level_data.mode:
		Config.GameDifficulties.FIELD_STANDARD:
			Achievements.raise_progress(Achievements.Achievements.FIELD_STANDARD)
		Config.GameDifficulties.FIELD_ROWDY:
			Achievements.raise_progress(Achievements.Achievements.FIELD_ROWDY)
		Config.GameDifficulties.FIELD_MAYHEM:
			Achievements.raise_progress(Achievements.Achievements.FIELD_MAYHEM)

		Config.GameDifficulties.TUNDRA_STANDARD:
			Achievements.raise_progress(Achievements.Achievements.TUNDRA_STANDARD)
		Config.GameDifficulties.TUNDRA_ROWDY:
			Achievements.raise_progress(Achievements.Achievements.TUNDRA_ROWDY)
		Config.GameDifficulties.TUNDRA_MAYHEM:
			Achievements.raise_progress(Achievements.Achievements.TUNDRA_MAYHEM)

		Config.GameDifficulties.DESERT_STANDARD:
			Achievements.raise_progress(Achievements.Achievements.DESERT_STANDARD)
		Config.GameDifficulties.DESERT_ROWDY:
			Achievements.raise_progress(Achievements.Achievements.DESERT_ROWDY)
		Config.GameDifficulties.DESERT_MAYHEM:
			Achievements.raise_progress(Achievements.Achievements.DESERT_MAYHEM)

	victory.emit()

func _spawn_item():

	# Ensure there are less items than the limit
	if len(get_tree().get_nodes_in_group("MapSpawned")) >= level_data.item_limit:
		return

	# Create and set item
	var new_item:Item = item_scn.instantiate()
	new_item.id = weighted_random_choice(spawn_items)

	# Ensure item exists
	if (not new_item) or not map_limit:
		return

	new_item.add_to_group("MapSpawned")
	items.add_child(new_item)

	var size = map_limit.shape.get_rect().size
	for x in range(5):
		new_item.global_position = Vector2(
			randi_range(map_limit.global_position.x - size.x/2, map_limit.global_position.x + size.x/2),
			randi_range(map_limit.global_position.y - size.y/2, map_limit.global_position.y + size.y/2)
		)
		for child in new_item.spawn_collider.get_overlapping_bodies():
			print("Test")
			if child is TileMapLayer:
				print("Done did it")
				continue
		break

func _physics_process(delta: float) -> void:
	current_spawn_cooldown += delta
	if current_spawn_cooldown > spawn_cooldown:
		_spawn_item()
		current_spawn_cooldown = 0

func _process(delta) -> void:
	## Update the health vignette
	#if player:
		#var health_perc = 1 - player.health / player.max_health
		#health_perc = health_vignette_curve.sample(health_perc)
		#vignette_shader.set_shader_parameter("MainAlpha", max(0, 1-(health_perc+0.6)))
		#vignette_shader.set_shader_parameter("OuterRadius", max(0, (5-(health_perc+0.6)*5)/2 + 0.01))
	

	# Update canvasmodulate nodes
	storm_modulate_node.goal = Color(1,1,1)
	if EventMan.is_event(EventMan.Events.STORM):
		storm_modulate_node.goal = storm_modulate_node.goal.blend(Color(0.573, 0.531, 0.823, 1))
	if EventMan.is_event(EventMan.Events.VOLCANO):
		storm_modulate_node.goal = storm_modulate_node.goal.blend(Color(1, 0.71, 0.42, 1))
	if EventMan.is_event(EventMan.Events.BLIZZARD):
		storm_modulate_node.goal = storm_modulate_node.goal.blend(Color(1, 1, 1.5, 1))
	if EventMan.is_event(EventMan.Events.TORNADO):
		if player.camera.trauma < 0.03:
			player.camera.trauma = 0.03
		storm_modulate_node.goal = storm_modulate_node.goal.blend(Color(0.735, 0.79, 0.749, 1))
	if EventMan.is_event(EventMan.Events.EARTHQUAKE):
		if player.camera.trauma < 0.08:
			player.camera.trauma = 0.08

	# Update stress and weather events
	strength += strength_increase / 60 * delta * 0.75
	current_event_cooldown += delta
	
	if current_event_cooldown > event_spawn_cooldown:
		current_event_cooldown = 0
		for x in range(level_data.event_multiplier):
			if ((randi() % 2) == 0) or (strength < 2):
				EventMan.spawn_event(events.pick_random(), self, max(1, strength))
			elif (randi() % 2) == 0 or (strength < 3):
				EventMan.spawn_event(events.pick_random(), self, max(1, strength/2))
				EventMan.spawn_event(events.pick_random(), self, max(1, strength/2))
			else:
				EventMan.spawn_event(events.pick_random(), self, max(1, strength/3))
				EventMan.spawn_event(events.pick_random(), self, max(1, strength/3))
				EventMan.spawn_event(events.pick_random(), self, max(1, strength/3))
		

## Gets a random value from a weighted dictionary (value: weight pairs)
func weighted_random_choice(weighted_dict: Dictionary) -> Variant:
	var total_weight = 0
	for weight in weighted_dict.values():
		total_weight += weight

	var random_pick = randf() * total_weight
	var cumulative_weight = 0

	for key in weighted_dict.keys():
		cumulative_weight += weighted_dict[key]
		if random_pick < cumulative_weight:
			return key

	return null  # This should never be reached if weights are valid

func get_station_count(type:StationData.Stations) -> int: ## Gets the number of 'type' stations
	var count:int = 0
	if not get_tree(): # Occurs if game is closing
		return count
	for child in get_tree().get_nodes_in_group("station"):
		if child.station_data == type and child.active:
			count += 1
	return count

func update_station_stats(): ## Updates variables dependent on stations
	if player:
		player.update_collector_stack_lim()

func player_stat_update(_player:Player, delta:float): ## "Weather" of the level; update player stats (temp)
	if player:
		player.state.temp.val -= level_data.temp_drain * delta

func get_upgrades() -> Dictionary[Upgrades.Upgrades, int]: ## Returns a dictionary of the player's upgrades
	return player.upgrades
