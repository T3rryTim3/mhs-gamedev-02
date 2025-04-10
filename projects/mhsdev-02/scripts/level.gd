extends Node2D
class_name Level

## Scene for creating new items
@onready var item_scn = preload("res://scenes/Base/item.tscn")

## Scene for creating UI
@onready var ui_layer_scn = preload("res://scenes/UI/game_ui.tscn")

## Curve for health vignette
@export var health_vignette_curve:Curve

## Limit for the map (just a collisionshape2d)
@export var map_limit:CollisionShape2D

## Spawn cooldown for items
@export_range(0,10) var spawn_cooldown:float = 3

## Stress increase per minute.
@export var strength_increase:float = 1

@export var spawn_items:Dictionary[ItemData.ItemTypes, int] = {
	ItemData.ItemTypes.WHEAT: 10,
}

@export var events:Array[EventMan.Events]

# Seconds between each event
@export var event_spawn_cooldown:float = 10

# Cooldown for next item spawn
var current_spawn_cooldown:float = 0

## Location to store items
var items:Node

## Location to store stations
var stations:Node

## Its the player.. what else?
var player:Player

## Canvaslayer with ui elements
var ui_layer:CanvasLayer

## Strength of spawned weather events.
var strength:float = 0.0

## Current cooldown before event spawning
var current_event_cooldown:float = 0

## Health vignette
@onready var vignette_shader = load("res://Shaders/health_vignette.tres")

func _ready():
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

	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("WARNING: PLAYER NOT FOUND")
	
	# Create ui
	ui_layer = ui_layer_scn.instantiate()
	add_child(ui_layer)

	# Connect updates for station effects
	stations.child_order_changed.connect(update_station_stats)

func _spawn_item():
	# Create and set item
	var new_item:Item = item_scn.instantiate()
	new_item.id = weighted_random_choice(spawn_items)

	# Ensure item exists
	if (not new_item) or not map_limit:
		return

	items.add_child(new_item)

	var size = map_limit.shape.get_rect().size
	new_item.global_position = Vector2(
		randi_range(map_limit.global_position.x - size.x/2, map_limit.global_position.x + size.x/2),
		randi_range(map_limit.global_position.y - size.y/2, map_limit.global_position.y + size.y/2)
	)

func _physics_process(delta: float) -> void:
	current_spawn_cooldown += delta
	if current_spawn_cooldown > spawn_cooldown:
		_spawn_item()
		current_spawn_cooldown = 0

func _process(delta) -> void:
	# Update the health vignette
	var health_perc = 1 - player.health / player.max_health
	health_perc = health_vignette_curve.sample(health_perc)
	vignette_shader.set_shader_parameter("MainAlpha", max(0, 1-(health_perc+0.6)))
	vignette_shader.set_shader_parameter("OuterRadius", max(0, (5-(health_perc+0.6)*5)/2 + 0.01))
	
	# Update stress and weather events
	strength += strength_increase / 60 * delta
	current_event_cooldown += delta
	
	if current_event_cooldown > event_spawn_cooldown:
		current_event_cooldown = 0
		EventMan.spawn_event(events.pick_random(), self, max(1, strength))

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
		var player_strength = 1 + get_station_count(StationData.Stations.STRENGTH_TOTEM)
		player.update_collector_stack_lim(player_strength)

func player_stat_update(_player:Player, delta:float): ## "Weather" of the level; update player stats (temp)
	player.state.temp.val -= 0.4 * delta

func get_upgrades() -> Dictionary[Upgrades.Upgrades, int]: ## Returns a dictionary of the player's upgrades
	return player.upgrades
