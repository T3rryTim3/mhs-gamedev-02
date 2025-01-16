extends Node2D
class_name Level

## Location to store items
@export var items:Node

## Location to store stations
@export var stations:Node

## Current player
@export var player:Player

func _ready():
	stations.child_order_changed.connect(update_station_stats)

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
	
	
