extends Node2D
class_name Collector
## Holds resources in a stack on top of eachother.
## Used to add "Inventory" slots to other nodes.

## How many items at a time that the collector can hold.
@export var stack_limit:int = 1

## The vertical distance between items in the stack.
@export var stack_distance:int = 48

## The random offset of dropping items
@export var drop_offset:int = 5

## The coefficient applied to the decay rate of collected items; makes items last longer/shorter
@export var decay_coef:float = 0.5

## The time from the item being collected to it being held
@export_range(0,2) var pickup_time:float = 0.5

## How high up the item is lifted when being collected - animation only
@export_range(0,192) var pickup_height:float = 48

## Area2D Node for detecting items to pick up.
@export var pickup_area:Area2D

## Node2D Defining where items will be picked up.
@export var pickup_pos_node:Node2D

## Default drop position node
@export var drop_pos_node:Node2D

## Tracker used to identify / separate items
var current_item_id:int = 0

## Current resources in the stack. (FILO)
var current_resources:Array = []

func _ready() -> void:
	pass

func _remove_item(item_id:int) -> void: ## Remove an item from current_resources by identifier
	for i in current_resources.size():
		if current_resources[i].collection_id == item_id:
			current_resources.remove_at(i)
			return

func _physics_process(delta: float) -> void:
	# Test: pickup nearest item
	if Input.is_action_just_pressed("ui_down"):
		print("--\ngrabin'")
		add_nearest_item()
	if Input.is_action_just_pressed("ui_up"):
		drop_item()

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
			item.position.y -= (item.collect_progress * (i*stack_distance)) / 2

func _get_nearest_item() -> Item: ## Get the nearest Item node not currently in a collector.
	var nearest_distance:float = INF
	var nearest_obj:PhysicsBody2D

	# Loop through items within range
	for body in pickup_area.get_overlapping_bodies():
		var distance = pickup_pos_node.global_position.distance_to(body.global_position)
		if distance < nearest_distance and not (body.get_parent() is Collector):
			nearest_distance = distance
			nearest_obj = body

	return nearest_obj

func add_nearest_item():
	var nearest_item = _get_nearest_item()
	if not nearest_item:
		print("No item found.")
		return
	add_item(nearest_item)

func add_item(item:Item) -> void: ## Add an item to the top of the stack.
	# Reparent item
	
	if len(current_resources) >= stack_limit:
		return
	
	var global_pos = item.global_position
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
	print(item.get_parent().get_class())
	print("Added item to collector!")

func _reset_item_stats(item:Item) -> void: ## Reset connections and other variables of an item.
	_remove_item(item.collection_id)
	item.collect_progress = 0
	item.collector_decay_coef = 1
	item.tree_exiting.disconnect(_remove_item)

func drop_item() -> void: ## Drop the topmost item.
	# Validate request
	if len(current_resources) == 0:
		print("Can't drop item: Collector empty")
		return

	var item:Item = current_resources[-1] # Get topmost item

	_reset_item_stats(item)

	item.position = drop_pos_node.position + Vector2(randi_range(-drop_offset, drop_offset), randi_range(-drop_offset, drop_offset))
	var glob_pos:Vector2 = item.global_position

	# Reparent item to root
	remove_child(item)
	get_tree().get_root().add_child(item)

	# Reset position back
	item.global_position = glob_pos
