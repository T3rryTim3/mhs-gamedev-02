extends Control

var blueprint_cycle_resource = preload("res://scenes/Structure/blueprint_cycle_option.tscn")

## Possible stations (cycling options)
var stations:Array = [
	StationData.Stations.WELL,
	StationData.Stations.CROP,
	StationData.Stations.QUARRY,
	StationData.Stations.FOREST,
	StationData.Stations.OVEN
]

# F Q C
var current_rects:Array = []

var selection_index:int = 0

var item_count:int = 5

var selected:StationData.Stations

var center_pos:Vector2

var progress:float = PI/2
var max_progress:float = 3*(PI/2) + PI/4
var min_progress:float = PI/2 - PI/4
var delta_progress:float = 0.0

func _ready() -> void:
	center_pos = get_viewport_rect().get_center() + Vector2(0,get_viewport_rect().size.y/2 + 48)
	for i in range(item_count):
		# Create the station
		var cycle_option: TextureRect = blueprint_cycle_resource.instantiate()
		add_child(cycle_option)
		
		# Set some stuff
		cycle_option.station_index = (selection_index + i) % len(stations)
		cycle_option.station = stations[cycle_option.station_index]
		current_rects.append(cycle_option)
		
		# Set to default position
		var current_progress = ((max_progress-min_progress) / item_count) * i + progress
		_set_center_pos(cycle_option, get_position_at_progress(current_progress, cycle_option))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		delta_progress = 4
	elif event.is_action_pressed("ui_left"):
		delta_progress = -4

func get_position_at_progress(current_progress:float, rect:TextureRect) -> Vector2:
	current_progress = fposmod(current_progress - min_progress, max_progress - min_progress) + min_progress # Keeps within range
	return (Vector2(sin(current_progress),cos(current_progress)) * 200) + center_pos

func _set_center_pos(rect:TextureRect, pos:Vector2) -> void: ## Sets the center position of a rect
	rect.position = pos - Vector2(rect.size.x * rect.scale.x * 0.5, rect.size.y * rect.scale.y * 0.5)

func _get_center_pos(rect) -> Vector2:
	return rect.position + Vector2(rect.size.x * rect.scale.x * 0.5, rect.size.y * rect.scale.y * 0.5)

func _process(delta: float) -> void:
	var change = delta_progress*delta
	progress = fmod(progress+change, max_progress-min_progress)

	# Update positions of stations
	for i in range(len(current_rects)):
		var current_progress
		current_progress = ((max_progress-min_progress) / item_count) * i + progress
		
		var last = _get_center_pos(current_rects[i])
		_set_center_pos(current_rects[i], get_position_at_progress(current_progress, current_rects[i]))
		var new = _get_center_pos(current_rects[i])
		var center = get_viewport_rect().get_center()

		# Handle cycling to the left
		if last.x < center.x and new.x > center_pos.x:
			if new.y < center_pos.y:
				if not Input.is_action_pressed("ui_left"):
					delta_progress = 0
				selected = current_rects[i].station
			else:
				current_rects[i].station_index = posmod(current_rects[i].station_index - item_count, len(stations))
				current_rects[i].station = stations[current_rects[i].station_index]

		# Handle cycling to the right
		elif last.x > center.x and new.x < center_pos.x:
			if new.y < center_pos.y:
				if not Input.is_action_pressed("ui_right"):
					delta_progress = 0
				selected = current_rects[i].station
			else:
				current_rects[i].station_index = posmod(current_rects[i].station_index + item_count, len(stations))
				current_rects[i].station = stations[current_rects[i].station_index]

		# Set size/modulation
		var true_progress = fposmod(current_progress - min_progress, max_progress - min_progress) + min_progress
		var scale_val = sin(PI*(true_progress-min_progress)/(max_progress-min_progress))
		current_rects[i].scale.x = scale_val * 2
		current_rects[i].scale.y = scale_val * 2
		#current_rects[i].modulate.a = scale_val
