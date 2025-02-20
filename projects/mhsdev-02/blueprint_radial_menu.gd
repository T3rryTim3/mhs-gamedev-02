extends Control

var stations:Array = [
	StationData.Stations.WELL,
	StationData.Stations.OVEN,
	StationData.Stations.CROP,
]

@onready var center:TextureRect = $center

## Time it takes to cycle fully
@export var cycle_time:float = 1

## If the menu is currently cycling
var cycling:bool = false

## Current progress in animation
var cycle_progress:float = 0

## Current cycling direction
var cycle_dir:int = 0

func _process(delta: float) -> void:
	if cycling:
		cycle_progress = clampf(cycle_progress + delta, 0, cycle_time)

	if cycle_dir == -1:
		pass

func cycle_left() -> void:
	if cycling:
		return
	cycling = true
	cycle_dir = -1

func cycle_right() -> void:
	if cycling:
		return
