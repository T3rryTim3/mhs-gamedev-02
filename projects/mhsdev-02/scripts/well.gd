extends Station
class_name Well

func produce():
	super()
	create_item(ItemData.ItemTypes.WATER, Vector2(1, randf_range(-1,1)))
