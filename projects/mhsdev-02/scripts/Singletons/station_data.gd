extends Node

enum Stations {
	WELL,
	CROP,
	QUARRY,
	FOREST,
	OVEN,
	STRENGTH_TOTEM
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
		5: # Strength totem
			return "res://scenes/Stations/strength_totem.tscn"

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
		5: # Strength totem
			return "res://images/stations/well.png"

func get_station_cost(station:Stations):
	match station:
		0: # Well
			return {
				ItemData.ItemTypes.ROCK: 3,
				ItemData.ItemTypes.WOOD: 2,
			}
		1: # Crop
			return {
				ItemData.ItemTypes.ROCK: 2,
				ItemData.ItemTypes.WOOD: 3,
			}
		2: # Quarry
			return {
				ItemData.ItemTypes.ROCK: 5,
				ItemData.ItemTypes.WOOD: 2
			}
		3: # Forest
			return {
				ItemData.ItemTypes.ROCK: 2,
				ItemData.ItemTypes.WOOD: 5
			}
		4: # Oven
			return {
				ItemData.ItemasTypes.ROCK: 3,
				ItemData.ItemTypes.WOOD: 3
			}
		5: # Strength Totem
			return {
				ItemData.ItemasTypes.WHEAT: 1,
				ItemData.ItemTypes.WOOD: 1
			}
		_: # Else
			return {
				
			}
