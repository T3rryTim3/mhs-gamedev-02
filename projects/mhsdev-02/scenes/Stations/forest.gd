extends Station
class_name Forest

func produce():
	super()
	create_item(Item.ItemTypes.WOOD, Vector2(1, randf_range(-1,1)))
 
