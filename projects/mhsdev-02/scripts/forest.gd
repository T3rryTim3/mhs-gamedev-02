extends Station
class_name Forest

func produce():
	super()
	if randf_range(0,1) < 0.2:
		create_item(ItemData.ItemTypes.ACORN, Vector2(randf_range(-1,1), 1))
	else:
		create_item(ItemData.ItemTypes.WOOD, Vector2(randf_range(-1,1), 1))
