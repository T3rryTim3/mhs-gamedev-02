extends Node2D
class_name Blueprint

enum LayerBehaviour
{
	ADAPTIVE,
	BELOW,
	ABOVE
}

## Behavoir for display in relation to the player
@export var layer_behavior:LayerBehaviour = LayerBehaviour.ADAPTIVE

## Station texture of blueprint
@onready var sprite = $Sprite2D

## Collector
@onready var collector:Collector = $Collector

## Cost display object
@onready var cost_item = preload("res://scenes/UI/cost_item.tscn")

## Cost to build
@onready var cost = StationData.get_station_cost(target_station)

## Station to be built
@export var target_station:StationData.Stations

## Resources currently spent to build
var spent_resources:Dictionary = {}

## Cooldown timer
var cooldown_timer:float = 0.0

## Cooldown limit
var cooldown_limit:float = 1.0

## Stops certain functions
var completing = false

func get_sprite_texture() -> Texture2D:
	if sprite is Sprite2D:
		return sprite.texture
	if sprite is AnimatedSprite2D:
		return sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
	print("ERROR: INVALID SRPITE SET")
	return null

func _ready():
	# Get station texture
	sprite.texture = load(StationData.get_station_texture(target_station))
	
	sprite.material.set_shader_parameter("blue", 1)
	
	collector.stack_limit = 0
	
	# Ready resource display
	for k in cost:
		spent_resources[k] = 0
		collector.stack_limit += cost[k]
		
		# Add display
		var item = cost_item.instantiate()
		$VBoxContainer.add_child(item)
		
		item.label.text = "0/" + str(cost[k])
		item.texture_rect.texture = load(ItemData.get_item_data(k)["img_path"])
		item.id = k

func _complete():
	completing = true
	
	# Remove all labels## Behavoir for display in relation to the player
	for child in $VBoxContainer.get_children():
		child.queue_free()
	
	# Add station scene
	var station_scene = load(StationData.get_station_scene(target_station))
	var station = station_scene.instantiate()
	
	station.global_position = global_position
	get_parent().add_child(station)
	queue_free()

func _check_completion():
	for k in spent_resources:
		if spent_resources[k] < cost[k]:
			return
	_complete()

func _update_label():
	for k in $VBoxContainer.get_children():
		k.label.text = str(spent_resources[k.id]) + "/" + str(cost[k.id])

func _process(delta: float) -> void:
	if not completing:
		cooldown_timer += delta
		if cooldown_timer > cooldown_limit:
			#_collect()
			cooldown_timer = 0
	match layer_behavior:
		0:
			# Check if the player is above the station based on camera pos
			if get_viewport().get_camera_2d().global_position.y + 24 <global_position.y + get_sprite_texture().get_height()/2.0:
				z_index = 5
			else:
				z_index = -1
		1:
			z_index = -1
		2: 
			z_index = 5

func _collect():
	# Collect and filter nearby items
	for k in cost:
		if spent_resources[k] >= cost[k]:
			continue
		collector.add_nearest_item(k)

	for k in cost:
		spent_resources[k] = 0

	for k in collector.current_resources:
		spent_resources[k.id] += 1

	_update_label()
	_check_completion()

func _on_collector_item_reset() -> void:
	_update_label()
	_check_completion()

func _on_collector_item_given(item) -> void:
	for k in cost:
		if item.id == k and cost[k] - spent_resources[k] > 0:
			collector.add_item(item)
			spent_resources[k] += 1
	_update_label()
	_check_completion()
			
