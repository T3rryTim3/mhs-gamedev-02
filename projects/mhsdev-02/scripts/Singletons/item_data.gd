extends Node

enum ItemTypes
{
	WOOD,
	WHEAT,
	BREAD,
	WATER,
	ROCK
}

func get_item_data(id:ItemTypes):
	
	var img_path = "res://images/items/wheat.png" # Default texture
	var decay_rate = 0.05
	var health = 1
	
	match id:
		0: # Wood
			health = 8
			decay_rate = 0
			img_path = "res://images/items/wood.png"
		1: # Wheat
			health = 3
			decay_rate = 0.2
			img_path = "res://images/items/wheat.png"
		2: # Bread
			health = 6
			decay_rate = 0.2
			img_path = "res://images/items/bread.png"
		3: # Water
			health = 1
			decay_rate = 0.01
			img_path = "res://images/items/water.png"
		4: # Rock
			health = 15
			decay_rate = 0
			img_path = "res://images/items/rock.png"
