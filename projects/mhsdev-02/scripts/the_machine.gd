extends StaticBody2D
class_name Machine

## Cost display object
@onready var cost_item = preload("res://scenes/UI/cost_item.tscn")

## Collector
@onready var collector = $Collector

## Object containing the cost display objects
@onready var cost_container:VBoxContainer = $VBoxContainer

## Currently spent resources
var spent_resources:Dictionary[ItemData.ItemTypes, int]

## Used for animation
var scale_val:float = 1.0

## The cost for the next station tier
var cost:Dictionary[ItemData.ItemTypes, int]

func _ready():
	cost = {
		ItemData.ItemTypes.WOOD: 1
	}
	select_cost(2, {ItemData.ItemTypes.WHEAT: 1, ItemData.ItemTypes.WOOD: 2})

	_display_cost()

func _process(_delta: float) -> void:
	if get_viewport().get_camera_2d().global_position.y + 24 <global_position.y + $Sprite2D.texture.get_height()/2.0:
		z_index = 5
	else:
		z_index = -1

## Set the cost of the machine based upon the price given. 
## 'Items' is the dict of items that can be chosen (Item, Price).
func select_cost(price:int, items:Dictionary[ItemData.ItemTypes, int]):
	cost = {}
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

func _update_label():
	for k in $VBoxContainer.get_children():
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
			spent_resources[k] += 1
			scale_val = 1
	_update_label()
	_check_completion()

func _update_cost():
	for k in cost_container.get_children():
		k.label.text = str(spent_resources[k.id]) + "/" + str(cost[k.id])
