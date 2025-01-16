extends Station
class_name Quarry

func produce():
	super()
	create_item(ItemData.ItemTypes.ROCK, Vector2(randf_range(-1,1), 1))
