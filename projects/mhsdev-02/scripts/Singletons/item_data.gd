extends Node

enum ItemTypes
{
	WOOD,
	WHEAT,
	BREAD,
	WATER,
	ROCK
}

func get_item_data(id:ItemTypes) -> Dictionary:
	
	var img_path = "res://images/items/wheat.png" # Default texture
	var decay_rate = 0.05
	var health = 1
	
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
			img_path = "res://images/items/bread.png"
		ItemTypes.WATER:
			health = 1
			decay_rate = 0.01
			img_path = "res://images/items/water.png"
		ItemTypes.ROCK:
			health = 15
			decay_rate = 0
			img_path = "res://images/items/rock.png"
	return {
		"health": health,
		"decay_rate": decay_rate,
		"img_path": img_path,
		"id": id
	}

func use_item(item:Item, player:Player):
	match item.id:
		ItemTypes.WOOD:
			pass
		ItemTypes.WHEAT:
			pass
		ItemTypes.BREAD:
			player.state.hunger.val += 20
			item.queue_free()
		ItemTypes.WATER:
			player.state.thirst.val += 20
			item.queue_free()
		ItemTypes.ROCK:
			pass
