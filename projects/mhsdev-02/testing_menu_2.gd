extends Control

signal new_station

var stations:Array = [
	StationData.Stations.WELL,
	StationData.Stations.CAMPFIRE,
	StationData.Stations.OVEN,
	StationData.Stations.STRENGTH_TOTEM
]

@onready var cost_item = preload("res://scenes/UI/cost_item.tscn")

var current_index = 0 : set = _set_station

func _set_station(new):
	# Keep new within range
	new = posmod(new, len(stations))

	# Destroy cost objects
	for child in $TextureRect/VBoxContainer.get_children():
		child.queue_free()

	$TextureRect.texture = load(StationData.get_station_texture(stations[new]))
	# Create new cost objects
	var cost = StationData.get_station_cost(stations[new])
	for k in cost:
		# Add display
		var item = cost_item.instantiate()
		$TextureRect/VBoxContainer.add_child(item)
		
		item.label.text = "0/" + str(cost[k])
		item.texture_rect.texture = load(ItemData.get_item_data(k)["img_path"])
		item.id = k

	# Assign new value
	current_index = new

	new_station.emit(stations[new])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					current_index += 1
				MOUSE_BUTTON_WHEEL_DOWN:
					current_index -= 1

func _ready() -> void:
	_set_station(0)
