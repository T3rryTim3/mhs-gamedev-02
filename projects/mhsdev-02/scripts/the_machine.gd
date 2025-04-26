extends StaticBody2D
class_name Machine

enum CostGroups {
	FIELD,
	TUTORIAL
}

## Cost display object
@onready var cost_item = preload("res://scenes/UI/cost_item.tscn")

## Collector
@onready var collector = $Collector

## Object containing the cost display objects
@onready var cost_container:VBoxContainer = $VBoxContainer

## The selected costs for the machine
@export var selected_costs:CostGroups

## The costs after being loaded from selected_costs
var costs:Array

## Currently spent resources
var spent_resources:Dictionary[ItemData.ItemTypes, int]

## Used for animation
var scale_val:float = 1.0

## The cost for the next station tier
var cost:Dictionary[ItemData.ItemTypes, int]

## The current index in the 'selected_costs' array
var cost_index:int = 0

func _load_costs(): ## Loads the costs from 'selected_costs'
	match selected_costs:
		CostGroups.FIELD:
			costs = [
				[5,{ItemData.ItemTypes.WHEAT: 1, ItemData.ItemTypes.WOOD: 2}],
				[10,{ItemData.ItemTypes.WHEAT: 1, ItemData.ItemTypes.WOOD: 2}],
				[15,{ItemData.ItemTypes.WHEAT: 1, ItemData.ItemTypes.WOOD: 2, ItemData.ItemTypes.ROCK: 2}],
				[20,{ItemData.ItemTypes.BREAD: 3, ItemData.ItemTypes.WOOD: 2, ItemData.ItemTypes.ROCK: 2}],
				[25,{ItemData.ItemTypes.BREAD: 3, ItemData.ItemTypes.WOOD: 2, ItemData.ItemTypes.ROCK: 2}]
			]
		CostGroups.TUTORIAL:
			costs = [
				[3,{ItemData.ItemTypes.BREAD: 2, ItemData.ItemTypes.WATER: 0.5}]
			]

func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

func _next_cost(): ## Selects the next cost in 'costs'
	if cost_index >= len(costs): # If there are no more costs
		cost = {}
		#_update_cost()
		return
	select_cost(costs[cost_index][0], costs[cost_index][1])
	cost_index += 1

func _ready():
	cost = {
		ItemData.ItemTypes.WOOD: 1
	}
	_load_costs()
	_next_cost()
	_display_cost()

func _process(delta: float) -> void:
	if get_viewport().get_camera_2d().global_position.y + 24 <global_position.y + $Sprite2D.texture.get_height()/2.0:
		z_index = 5
	else:
		z_index = -1
	
	$Sprite2D.scale.y = scale_val
	scale_val = clampf(scale_val - 1 * delta, 1, 2)

## Set the cost of the machine based upon the price given. 
## 'Items' is the dict of items that can be chosen (Item, Price).
func select_cost(price:float, items):
	cost = {}
	collector.clear_items()
	while price > 0:
		# Stop if there are no more possible items
		if len(items) == 0:
			break

		var selection = items.keys()[randi_range(0,len(items)-1)]

		# Don't select if too expensive
		if price - items[selection] < 0:
			items.erase(selection)
			continue

		# Add to cost
		price -= items[selection]
		if cost.has(selection):
			cost[selection] += 1
		else:
			cost[selection] = 1

	for k in cost:
		spent_resources[k] = 0

func _display_cost():
	for child in cost_container.get_children():
		child.queue_free()
	for k in cost:
		var item = cost_item.instantiate()
		cost_container.add_child(item)
		item.label.text = "0/" + str(cost[k])
		item.texture_rect.texture = load(ItemData.get_item_data(k)["img_path"])
		item.id = k

func _update_cost():
	for k in cost_container.get_children():
		if not (k.id in cost):
			_display_cost()
			return
		k.label.text = str(spent_resources[k.id]) + "/" + str(cost[k.id])

func _check_completion():
	for k in cost:
		if cost[k] == spent_resources[k]:
			continue
		return false
	return true

func _on_collector_item_given(item) -> void:
	for k in cost.keys():
		if item.id == k and cost[k] - spent_resources[k] > 0:
			collector.add_item(item)
			collector.delete_item()
			spent_resources[k] += 1
	scale_val = 1.2
	
	if _check_completion():
		_get_level().machine_powered.emit()
		_get_level().player.give_upgrade.emit()
		_next_cost()
		_display_cost()
		_update_cost()
	else:
		_update_cost()
