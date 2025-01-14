extends Node2D
class_name Blueprint

## Station texture of blueprint
@onready var sprite = $Sprite2D

## Cost display object
@onready var cost_item = preload("res://scenes/UI/cost_item.tscn")

## Cost to build
@onready var cost = StationData.get_station_cost(target_station)

## Station to be built
@export var target_station:StationData.Stations

## Resources currently spent to build
var spent_resources:Dictionary = {}

func _ready():
	# Get station texture
	sprite.texture = load(StationData.get_station_texture(target_station))
	
	# Ready resource display
	for k in cost:
		spent_resources[k] = 0
		
		# Add display
		var item = cost_item.instantiate()
		$VBoxContainer.add_child(item)
		
		item.label.text = "0 /" + str(cost[k])
		
