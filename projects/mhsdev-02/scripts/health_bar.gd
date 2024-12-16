extends TextureProgressBar
class_name StatBar
## A progress bar made specifically to be used with entities.
## The top-left of the bar will become the middle upon calling refresh() (done at _ready())

## The width of the attatched texture
@export var texture_width:float

## The width of the attatched texture
@export var texture_height:float

## Padding (scale) between texture and bar.
@export var padding_scale:float = 1

## Scale of the bar compared to texture_width
@export var size_scale:float = 1

## Health bar thickness coefficient
@export var thickness:float = 1

## Determines the height of the healthbar, relative to the width.
@export var y_to_x_ratio:float = 0.05

## Grab relative offset before refresh() is called
@onready var x_offset = position.x

## Grab relative offset before refresh() is called
@onready var y_offset = position.y

## Lerp per frame (accounting for delta)
var lerp_val:float = 0.04

## Current progress (0-1)
var current:float = 1

## Used to keep track of progress with more precision
var true_value:float = 1

func _ready() -> void:
	refresh()

func _process(_delta: float) -> void:
	# Lerp to current progress
	true_value = lerpf(true_value, current*max_value, lerp_val)
	value = int(true_value)

func refresh() -> void: ## Refresh the bar's size and position. Does not affect progress
	scale.x = (1.0/texture_progress.get_width()) * texture_width * size_scale
	scale.y = y_to_x_ratio * scale.x
	position.x = -(texture_width * size_scale)/2 + x_offset
	position.y = y_offset + scale.y * padding_scale * texture_progress.get_height()
