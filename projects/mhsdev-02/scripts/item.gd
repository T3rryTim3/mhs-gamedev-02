extends Entity
class_name Item

## Collider for item spawning
@onready var spawn_collider:Area2D = $SpawnCollider

## Item ID
@export var id:ItemData.ItemTypes

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

## Pickup sound stream player
var pickup_stream:AudioStreamPlayer2D

# Variables for item usage progress
var item_usage_progress:float = 0
var item_usage_max:float
var using:bool = false

func _ready() -> void:
	# Assign base stats based on resource
	var data = ItemData.get_item_data(id)
	health = data["health"]
	decay_rate = data["decay_rate"]
	img_path = data["img_path"]
	item_usage_max = data["use_time"]
			
	var image = load(img_path)
	$Sprite2D.texture = image
	
	var audio_stream = AudioStreamPlayer2D.new()
	audio_stream.autoplay = false
	audio_stream.playing = false
	audio_stream.stream = load(data["pickup_sound"])
	add_child(audio_stream)
	pickup_stream = audio_stream
	
	super()

func enable_outline() -> void:
	sprite.material.set("shader_parameter/thickness", 0.7)

func play_pickup_sound() -> void: ## Play the item's pickup sound
	pickup_stream.play()

func disable_outline() -> void:
	sprite.material.set("shader_parameter/thickness", 0)

func _process(delta: float) -> void:
	super(delta)
	_update_health(health - (decay_rate * collector_decay_coef) * delta)
