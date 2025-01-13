extends Station
class_name Quarry

func produce():
	super()
	create_item(Item.ItemTypes.ROCK, Vector2(1, randf_range(-1,1)))
