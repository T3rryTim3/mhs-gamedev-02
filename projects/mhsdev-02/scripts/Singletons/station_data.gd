extends Node

enum Stations {
	WELL,
	CROP,
	QUARRY,
	FOREST,
	OVEN,
}

func get_station_scene(station:Stations):
	match station:
		0: # Well
			return "res://scenes/Stations/well.tscn"
		1: # Crop
			return "res://scenes/Stations/wheat_crop.tscn"
		2: # Quarry
			return "res://scenes/Stations/quarry.tscn"
		3: # Forest
			return "res://scenes/Stations/forest.tscn"
		4: # Oven
			return "res://scenes/Stations/oven.tscn"

func get_station_texture(station:Stations):
	match station:
		0: # Well
			return "res://images/stations/well.png"
		1: # Crop
			return "res://images/stations/crop.png"
		2: # Quarry
			return "res://images/stations/quarry.png"
		3: # Forest
			return "res://images/stations/forest.png"
		4: # Oven
			return "res://images/stations/well.png"

func get_station_cost(station:Stations):
	match station:
		0: # Well
			return {
				ItemData.ItemTypes.ROCK: 2,
				ItemData.ItemTypes.WOOD: 1
			}
		1: # Crop
			return {
				ItemData.ItemTypes.ROCK: 2,
				ItemData.ItemTypes.WOOD: 1
			}
		2: # Quarry
			return {
				ItemData.ItemTypes.ROCK: 2,
				ItemData.ItemTypes.WOOD: 1
			}
		3: # Forest
			return {
				ItemData.ItemTypes.ROCK: 2,
				ItemData.ItemTypes.WOOD: 1
			}
		4: # Oven
			return {
				ItemData.ItemTypes.ROCK: 2,
				ItemData.ItemTypes.WOOD: 1
			}
		_: # Else
			return {
				
			}
