extends Node

enum Stations {
	WELL,
	CROP,
	QUARRY,
	FOREST,
	OVEN,
	STRENGTH_TOTEM,
	SPEED_TOTEM,
	CAMPFIRE
}

func get_station_name(station:Stations) -> String:
	match station:
		Stations.WELL:
			return "Well"
		Stations.CROP:
			return "Crop"
		Stations.QUARRY:
			return "Quarry"
		Stations.FOREST:
			return "Forest"
		Stations.OVEN:
			return "Oven"
		Stations.STRENGTH_TOTEM:
			return "Strength Totem"
		Stations.SPEED_TOTEM:
			return "Speed Totem"
		Stations.CAMPFIRE:
			return "Campfire"
		_:
			return "NAME ERROR"

func get_station_scene(station:Stations):
	match station:
		Stations.WELL: # Well
			return "res://scenes/Stations/well.tscn"
		Stations.CROP: # Crop
			return "res://scenes/Stations/wheat_crop.tscn"
		Stations.QUARRY: # Quarry
			return "res://scenes/Stations/quarry.tscn"
		Stations.FOREST: # Forest
			return "res://scenes/Stations/forest.tscn"
		Stations.OVEN: # Oven
			return "res://scenes/Stations/oven.tscn"
		Stations.STRENGTH_TOTEM: # Strength totem
			return "res://scenes/Stations/strength_totem.tscn"
		Stations.CAMPFIRE: # Strength totem
			return "res://scenes/Stations/campfire.tscn"

func get_station_texture(station:Stations):
	match station:
		Stations.WELL: # Well
			return "res://images/stations/well.png"
		Stations.CROP:  # Crop
			return "res://images/stations/crop.png"
		Stations.QUARRY: # Quarry
			return "res://images/stations/quarry.png"
		Stations.FOREST: # Forest
			return "res://images/stations/forest.png"
		Stations.OVEN: # Oven
			return "res://images/stations/oven(off).png"
		Stations.STRENGTH_TOTEM: # Strength totem
			return "res://images/stations/Strength Totem (Regular).png"
		Stations.CAMPFIRE:
			return "res://images/stations/campfire(on).png"
		_:
			print("MISSING TEXTURE")
			return "res://images/stations/well.png"
			

func get_station_cost(station:Stations):
	match station:
		Stations.WELL: # Well
			return {
				ItemData.ItemTypes.ROCK: 3,
				ItemData.ItemTypes.WOOD: 2,
			}
		Stations.CROP:  # Crop
			return {
				ItemData.ItemTypes.ROCK: 2,
				ItemData.ItemTypes.WOOD: 3,
			}
		Stations.QUARRY: # Quarry
			return {
				ItemData.ItemTypes.ROCK: 5,
				ItemData.ItemTypes.WOOD: 2
			}
		Stations.FOREST: # Forest
			return {
				ItemData.ItemTypes.ROCK: 2,
				ItemData.ItemTypes.WOOD: 5
			}
		Stations.OVEN: # Oven
			return {
				ItemData.ItemTypes.ROCK: 4,
			}
		Stations.STRENGTH_TOTEM: # Strength Totem
			return {
				ItemData.ItemTypes.WHEAT: 1,
				ItemData.ItemTypes.WOOD: 1
			}
		Stations.CAMPFIRE:
			return {
				ItemData.ItemTypes.WOOD: 4
			}
		_: # Else
			return {
				
			}
