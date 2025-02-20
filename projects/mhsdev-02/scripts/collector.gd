extends Node2D
class_name Collector
## Holds resources in a stack on top of eachother.
## Used to add "Inventory" slots to other nodes.

## Fires when an item is successfully added to the collector
signal item_collected

## Fires when an item's stats are wiped / when an item is removed
signal item_reset

## Fires when a collector drops an item into this one.
signal item_given

## Collector visual preload
@onready var display_scn = preload("res://scenes/Base/collector_display.tscn")

#region Exports
## How many items at a time that the collector can hold.
@export var stack_limit:int = 1

## The vertical distance between items in the stack.
@export var stack_distance:int = 48

## The random offset of dropping items
@export var drop_offset:int = 5

## Allows other collectors to pickup from this one
@export var can_steal:bool = false

## The coefficient applied to the decay rate of collected items; makes items last longer/shorter
@export var decay_coef:float = 0.5

## The time from the item being collected to it being held
@export_range(0,2) var pickup_time:float = 0.25

## How high up the item is lifted when being collected - animation only
@export_range(0,192) var pickup_height:float = 24

## Area2D Node for detecting items to pick up.
@export var pickup_area:Area2D

## Node2D Defining where items will be picked up.
@export var pickup_pos_node:Node2D

## Default drop position node
@export var drop_pos_node:Node2D

## Limit items picked up - enable
@export var limit_type_enable:bool = false

## Limit items picked up
@export var limit_type:ItemData.ItemTypes

## Toggle auto collect
@export var auto_collect:bool = false

## Auto collect cooldown
@export var auto_collect_cooldown:float = 1.0

## Loses grip after force is applied to item
@export var loose_grip:bool = true

## Show a crate with the limit_type item, if set
@export var show_crate:bool = true
#endregion

#region Variables
## Current progress for auto collecting
var auto_collect_progress:float = 0

## Tracker used to identify / separate items
var current_item_id:int = 0

## Current resources in the stack. (FILO)
var current_resources:Array = []

## Crate object
var display:Sprite2D
#endregion

#region Built in
func _ready() -> void:
	if show_crate:
		# Add crate
		display = display_scn.instantiate()
		add_child(display)
		display.position = pickup_pos_node.position + Vector2(0, 8) # Pixel offset

		if limit_type_enable:
			# Add crate display
			var data = ItemData.get_item_data(limit_type)
			var image = load(data["img_path"])
			display.inner.texture = image
		else:
			display.inner.visible = false

func _process(delta:float) -> void:
	if auto_collect:
		auto_collect_progress += delta
		if auto_collect_progress >= auto_collect_cooldown:
			add_nearest_item()
			auto_collect_progress = 0
	for x in current_resources:
		x.z_index = z_index

func _physics_process(delta: float) -> void:
	# Update collected item positions
	for i in current_resources.size():
		var item:Item = current_resources[i]
		if item.collect_progress <= pickup_time:
			# Update animation progress
			item.collect_progress = clampf(item.collect_progress + delta, 0, pickup_time)

			# Update position
			var total_progress = item.collect_progress / pickup_time
			item.position.x = lerpf(item.collect_start_pos.x, item.collect_goal.x, total_progress)
			# Use sin for arc shape
			item.position.y = -pickup_height * (sin((1/pickup_time)*PI*(item.collect_progress)))
			# Account for stack height
			item.position.y -= (item.collect_progress * ((i)*stack_distance)) / 2
#endregion

#region Utility
func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null
#endregion

#region Item Management

func cycle_items() -> void: ## Rotates the items around in ordering
	if current_resources.is_empty():
			return
	var last_item = current_resources.pop_back()
	current_resources.insert(0, last_item)

func _remove_item(item_id:int) -> void: ## Remove an item from current_resources by identifier
	for i in current_resources.size():
		if current_resources[i].collection_id == item_id:
			current_resources.remove_at(i)
			return

func _get_nearest_item(reset:bool = true, force_type: = -1) -> Item: ## Get the nearest Item node not currently in a collector.
	var nearest_distance:float = INF
	var nearest_obj:PhysicsBody2D

	# Loop through items within range
	for body in pickup_area.get_overlapping_bodies():
		if not (body is Item):
			continue
		var distance = pickup_pos_node.global_position.distance_to(body.global_position)
		if distance < nearest_distance:

			# Prevent collector stealing unless enabled
			if (body.get_parent() is Collector and not body.get_parent().can_steal):
				continue

			if body.get_parent() == self:
				continue

			# Prevent other items if limit
			if (body.id != limit_type) and (limit_type_enable):
				continue

			# Prevent from forced type
			if (force_type >= 0 and body.id != force_type):
				continue

			nearest_distance = distance
			nearest_obj = body

	# Reset stats if in collector
	if nearest_obj and nearest_obj.get_parent() is Collector and reset:
		if nearest_obj.get_parent() != self:
			nearest_obj.get_parent().reset_item_stats(nearest_obj)

	return nearest_obj

func add_nearest_item(force_type = -1) -> bool:
	var nearest_item = _get_nearest_item(true, force_type)
	if not nearest_item:
		return false
	return add_item(nearest_item)

func item_count() -> int:
	return len(current_resources)

func add_item(item:Item, skip_animation:bool=false) -> bool: ## Add an item to the top of the stack.
	# Reparent item
	
	if len(current_resources) >= stack_limit:
		return false

	# if item.global_position == pickup_pos_node.global_position:
		# skip_animation = true

	var global_pos = item.global_position
	if item.get_parent():
		item.get_parent().remove_child(item)
	add_child(item)

	# Update position
	item.global_position = global_pos
	item.collect_start_pos = item.position # Store relative start position (Should be (0,0))
	item.collect_goal = pickup_pos_node.position
	item.collector_decay_coef = decay_coef

	current_item_id += 1
	item.collection_id = current_item_id

	current_resources.append(item)
	item.tree_exiting.connect(_remove_item.bind(item.collection_id))
	item.force_applied.connect(_reparent_item.bind(item))

	item.z_index = z_index

	if skip_animation:
		item.collect_progress = pickup_time

	item_collected.emit()
	
	if decay_coef == 0:
		item.show_health = false

	return true

func reset_item_stats(item:Item) -> void: ## Reset connections and other variables of an item.
	_remove_item(item.collection_id)
	item.collect_progress = 0
	item.collector_decay_coef = 1
	item.tree_exiting.disconnect(_remove_item)
	item.force_applied.disconnect(_reparent_item.bind(item))
	item.show_health = true
	item.z_index = -1
	item_reset.emit()

func destroy_item() -> void: ## Destroy the top item
	if len(current_resources) == 0:
		return

	var item:Item = current_resources[-1] # Get topmost item
	reset_item_stats(item)
	
	item.queue_free()

func _reparent_item(item:Item): ## Reparent item to the level
	reset_item_stats(item)

	item.position = drop_pos_node.position + Vector2(randi_range(-drop_offset, drop_offset), randi_range(-drop_offset, drop_offset))
	var glob_pos:Vector2 = item.global_position

	# Reparent item to root
	remove_child(item)
	_get_level().call_deferred("add_child", item)

	# Reset position back
	item.global_position = glob_pos

func get_topmost_item() -> Item: ## Returns the topmost item.
	if len(current_resources) == 0:
		return null
	return current_resources[-1]

func item_entered(item:Item): ## Called by other collectors when an item is dropped nearby
	
	# Fire signal for custom pickup functionality
	item_given.emit(item)
	
	# Auto collect
	if auto_collect:
		if item.get_parent() is Collector:
			item.get_parent().reset_item_stats(item)
		add_item(item, true)

func drop_item() -> void: ## Drop the topmost item.
	# Validate request
	if len(current_resources) == 0:
		return

	var near_collector
	for area in $PickupRange.get_overlapping_areas():
		if not (area is Area2D):
			continue
		if not (area.get_parent() is Collector):
			continue
		near_collector = area

	var item:Item = current_resources[-1] # Get topmost item

	# Drop item or give it to an overlapping collector
	if near_collector:
		item.global_position = near_collector.get_parent().pickup_pos_node.global_position
		near_collector.get_parent().item_entered(item)
		if item.get_parent() == self: # If the collector did not accept the item
			_reparent_item(item)
	else:
		_reparent_item(item)
#endregion
	
