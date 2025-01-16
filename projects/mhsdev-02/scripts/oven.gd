extends Station

@onready var collector_wheat = $Collector
@onready var collector_wood = $Collector2

var pickup_timer:Timer

func produce():
	super()
	
	if (len(collector_wheat.current_resources) > 0) and (len(collector_wood.current_resources) > 0):
		collector_wheat.destroy_item()
		collector_wood.destroy_item()
	
		create_item(ItemData.ItemTypes.BREAD, Vector2(randf_range(-1,1), 1))
