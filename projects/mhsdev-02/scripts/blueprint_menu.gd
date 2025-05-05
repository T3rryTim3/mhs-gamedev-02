extends Control

signal new_station

var stations:Array = [
	StationData.Stations.WELL,
	StationData.Stations.CAMPFIRE,
	StationData.Stations.OVEN,
	#StationData.Stations.STRENGTH_TOTEM,
	#StationData.Stations.SPEED_TOTEM,
	StationData.Stations.WATER_PURIFIER,
	StationData.Stations.QUARRY,
	StationData.Stations.FOREST,
	StationData.Stations.CROP,
	StationData.Stations.BARRICADE
]

# All texturerects of the stations
var station_sprites : Array[TextureRect]

@onready var cost_item = preload("res://scenes/UI/cost_item.tscn")

var current_index = 0 : set = _set_station

func _set_station(new):
	# Keep new within range
	new = posmod(new, len(stations))

	# Destroy cost objects
	for child in $TextureRect/VBoxContainer.get_children():
		child.queue_free()

	$TextureRect.texture = load(StationData.get_station_texture(stations[new]))
	$TextureRect/Label.text = StationData.get_station_name(stations[new])
	$Label2.text = StationData.get_station_desc(stations[new])
	# Create new cost objects
	var cost = StationData.get_station_cost(stations[new])
	for k in cost:
		# Add display
		var item = cost_item.instantiate()
		$TextureRect/VBoxContainer.add_child(item)
		
		item.label.text = "0/" + str(cost[k])
		item.texture_rect.texture = load(ItemData.get_item_data(k)["img_path"])
		item.id = k

	station_sprites[current_index].self_modulate.a = 0.5
	station_sprites[new].self_modulate.a = 1

	# Assign new value
	current_index = new

	new_station.emit(stations[new])

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action("cycle_blueprint_up"):
			current_index -= 1
		elif event.is_action("cycle_blueprint_down"):
			current_index += 1	

func _ready() -> void:
	# Remove previous stations
	station_sprites = []
	for child in $VBoxContainer2.get_children():
		child.queue_free()

	# Load texturerects
	for i in range(len(stations)):
		var station_sprite: TextureRect = TextureRect.new()
		station_sprite.texture = load(StationData.get_station_texture(stations[i]))
		station_sprite.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		station_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		station_sprite.self_modulate.a = 0.5
		$VBoxContainer2.add_child(station_sprite)
		station_sprites.append(station_sprite)
	
	_set_station(0)
