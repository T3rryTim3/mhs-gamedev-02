extends Station
class_name Forest

func produce():
	super()
	create_item(ItemData.ItemTypes.WOOD, Vector2(randf_range(-1,1), 1))
 
