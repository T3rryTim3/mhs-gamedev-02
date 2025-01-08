extends Entity
class_name Item

enum ItemTypes
{
	WOOD,
	WHEAT,
	BREAD
}

## Item ID
@export var id:ItemTypes

## Speed which health diminishes over time (per second)
var decay_rate:float

## Decay adjustment based on collector
var collector_decay_coef:float = 1

## Image path
var img_path = ""

## Used in animating collectors
var collect_progress:float = 0

## Goal location when animated by collector
var collect_goal:Vector2 = Vector2.ZERO

## Used in animating collectors
var collect_start_pos:Vector2 = Vector2.ZERO

## Used to identify item when collected
var collection_id:int = 0

func _ready() -> void:
	# Assign base stats based on resource
	img_path = "res://images/items/wheat.png" # Default texture
	match id:
		0: # Wood
			health = 8
			decay_rate = 0
			img_path = "res://images/items/wheat.png"
		1: # Wheat
			health = 3
			decay_rate = 0.2
		2: # Bread
			health = 6
			decay_rate = 0.2
	var image = load(img_path)
	$Sprite2D.texture = image
	super()

func _process(delta: float) -> void:
	_update_health(health - (decay_rate * collector_decay_coef) * delta)
