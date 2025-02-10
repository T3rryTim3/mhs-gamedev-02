extends Node2D
class_name Level

## Location to store items
@export var items:Node

## Location to store stations
@export var stations:Node

## Current player
@export var player:Player

## Health vignette
@onready var vignette_shader = load("res://Shaders/health_vignette.tres")

func _ready():
	stations.child_order_changed.connect(update_station_stats)

func _process(_delta) -> void:
	var health_perc = player.health / player.max_health
	if health_perc < 0.4:
		vignette_shader.set_shader_parameter("MainAlpha", 1-(health_perc+0.6))
		vignette_shader.set_shader_parameter("OuterRadius", (5-(health_perc+0.6)*5)/2 + 0.01)
	else:
		vignette_shader.set_shader_parameter("MainAlpha", 0)
		vignette_shader.set_shader_parameter("OuterRadius", 5)


func _get_station_count(type:StationData.Stations) -> int: ## Gets the number of 'type' stations
	var count:int = 0
	if not get_tree(): # Occurs if game is closing
		return count
	for child in get_tree().get_nodes_in_group("station"):
		if child.station_data == type:
			count += 1
	return count

func update_station_stats(): ## Updates variables dependent on stations
	if player:
		var strength = 1 + _get_station_count(StationData.Stations.STRENGTH_TOTEM)
		player.update_collector_stack_lim(strength)

func player_stat_update(_player:Player, delta:float): ## "Weather" of the level; update player stats (temp)
	player.state.temp.val -= 0.4 * delta
