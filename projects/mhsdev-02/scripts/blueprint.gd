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

## Used for animation
var scale_val:float = 0

## Cooldown timer
var cooldown_timer:float = 0.0

## Cooldown limit
var cooldown_limit:float = 1.0

## Stops certain functions
var completing = false

## If the blueprint can currently be deleted
var can_delete:bool = false

func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

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
	
	var size = sprite.texture.get_size()
	
	$BlueprintCollider.collision_shape.shape.size = size
	$ColorRect.size = size
	$ColorRect.global_position = sprite.global_position - size/2
	$ShowRange/CollisionShape2D.shape.radius = size.x / 1.25
	$VBoxContainer.position.y -= 48 - size.y/2
	$VBoxContainer.hide()

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
	scale_val = clampf(scale_val - 8 * delta, 0, 1)
	sprite.scale.y = 1 + (0.2 * sin(PI * scale_val))
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

	var player:Player = _get_level().player
	var sizex = sprite.texture.get_size().x
	var sizey = sprite.texture.get_size().y
	var success = false

	var item_id = -1
	if len(player.collector.current_resources) > 0:
		item_id = player.collector.get_topmost_item().id

	# Check if the hovered item can be spent and is overlapping the blueprint
	if item_id != -1 and cost.has(item_id) and spent_resources[item_id] < cost[item_id]:
		var pos = player.current_item_display.global_position
		if (pos.x > global_position.x - sizex/2) and (pos.x < global_position.x + sizex/2):
			if (pos.y > global_position.y - sizey/2) and (pos.y < global_position.y + sizey/2):
				scale = Vector2(1.1,1.1)
				success = true
				if not (self in player.hovered_blueprints):
					player.hovered_blueprints.append(self)
	if not success: # Reset the size if not applicable
		if (self in player.hovered_blueprints):
			print("Erase.")
			player.hovered_blueprints.erase(self)
		scale = Vector2(1,1)

	_check_delete()

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
	for k in cost.keys():
		if item.id == k and cost[k] - spent_resources[k] > 0:
			collector.add_item(item)
			collector.delete_item()
			spent_resources[k] += 1
			scale_val = 1
	_update_label()
	_check_completion()

func _on_show_range_body_entered(body: Node2D) -> void:
	if body is Player:
		$VBoxContainer.show()

func _on_show_range_body_exited(body: Node2D) -> void:
	if body is Player:
		$VBoxContainer.hide()

#region Deletion handling
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if can_delete:
			queue_free()

func _check_delete():
	var glob_mouse = get_global_mouse_position()
	var sizex = get_sprite_texture().get_size().x
	var sizey = get_sprite_texture().get_size().y
	
	can_delete = false
	if (glob_mouse.x > global_position.x - sizex/2) and (glob_mouse.x < global_position.x + sizex/2):
		if (glob_mouse.y > global_position.y - sizey/2) and (glob_mouse.y < global_position.y + sizey/2):
			if _get_level().player.delete_mode:
				can_delete = true

	_update_remove_color(can_delete)

func _update_remove_color(on:bool):
	if on:
		sprite.self_modulate.r = 40
	else:
		sprite.self_modulate.r = 1
#endregion
