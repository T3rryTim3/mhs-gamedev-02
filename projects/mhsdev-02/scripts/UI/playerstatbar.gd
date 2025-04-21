extends TextureProgressBar

## Starting position (local)
var origin:Vector2

## Current cooldown until next shake
var current_shake_cooldown:float = 0

## Time between each shake
@export var shake_cooldown:float = 0.1

## Offset each shake
@export var shake_size:int = 2

## Maximum value before shaking
@export var threshold_perc:float = 100

func _ready():
	origin = position

func _process(delta: float) -> void:
	current_shake_cooldown += delta
	if value <= value * threshold_perc / max_value:
		if current_shake_cooldown >= shake_cooldown:
			current_shake_cooldown = 0
			position = origin + Vector2(randi_range(-shake_size,shake_size),randi_range(-shake_size,shake_size))
	else:
		position = origin
