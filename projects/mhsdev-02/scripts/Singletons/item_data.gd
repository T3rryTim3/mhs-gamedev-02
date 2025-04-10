extends Node

enum ItemTypes
{
	WOOD,
	WHEAT,
	BREAD,
	WATER,
	WATER_CLEAN,
	ROCK
}

func get_item_data(id:ItemTypes) -> Dictionary:
	
	var img_path = "res://images/items/wheat.png" # Default texture
	var decay_rate = 0.05
	var health = 1
	var use_time = 0
	
	match id:
		ItemTypes.WOOD:
			health = 8
			decay_rate = 0
			img_path = "res://images/items/wood.png"
		ItemTypes.WHEAT:
			health = 3
			decay_rate = 0.2
			img_path = "res://images/items/wheat.png"
		ItemTypes.BREAD:
			health = 6
			decay_rate = 0.2
			use_time = 1
			img_path = "res://images/items/bread.png"
		ItemTypes.WATER:
			health = 1
			decay_rate = 0.0
			use_time = 1
			img_path = "res://images/items/dirty_water.png"
		ItemTypes.WATER_CLEAN:
			health = 1
			decay_rate = 0.0
			use_time = 1
			img_path = "res://images/items/water.png"
		ItemTypes.ROCK:
			health = 15
			decay_rate = 0
			img_path = "res://images/items/rock.png"
	return {
		"health": health,
		"decay_rate": decay_rate,
		"img_path": img_path,
		"use_time": use_time,
		"id": id
	}

func use_item(item:Item, player:Player, delta:float):
	if item.using == false:
		item.item_usage_progress = 0
		item.using = true
	
	item.item_usage_progress += delta

	# If item fully used
	if item.item_usage_progress >= item.item_usage_max:
		match item.id:
			ItemTypes.WOOD:
				pass
			ItemTypes.WHEAT:
				pass
			ItemTypes.BREAD:
				player.state.hunger.val += 20
				item.queue_free()
			ItemTypes.WATER:
				player.state.thirst.val += 10
				item.queue_free()
			ItemTypes.WATER_CLEAN:
				player.state.thirst.val += 20
				item.queue_free()
			ItemTypes.ROCK:
				pass
		item.using = false
