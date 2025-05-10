extends Station

@onready var collector_water = $Collector

func _can_purify():
	return (len(collector_water.current_resources) > 0)

func produce():
	super()
	if _can_purify():
		collector_water.destroy_item()
		create_item(ItemData.ItemTypes.ROCK, Vector2(randf_range(-1,1), 1))
