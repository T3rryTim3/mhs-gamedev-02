# Used to keep track of stats throughout the game to be displayed to the player.
extends Node

## Amount of time spent on the current level
var level_time:float

## Amount of damage taken
var damage_taken:float # TODO

## Amount of stations placed
var stations_placed:int # TODO

## Amount of stations destroyed
var stations_destroyed:int # TODO

## Amount of weather events spawned
var events_spawned:int # TODO

func _ready():
	initialize()

func get_string() -> String: ## Returns a string version of the stats. Used for victory/death screens
	return "\n".join([
		"Time spent: " + str(roundf(level_time)),
		"Damage taken: " + str(roundf(damage_taken)),
		"Stations placed: " + str(stations_placed),
		"Stations destroyed: " + str(stations_destroyed),
		"Weather events spawned: " + str(events_spawned)
	])

func initialize():
	level_time = 0
	damage_taken = 0
	stations_placed = 0
	stations_destroyed = 0
	events_spawned = 0
