extends Station
class_name WheatCrop

@onready var collector = $Collector

var pickup_timer:Timer

var decay_rate:float = 0.2

func produce():
	super()

	if collector.item_count() > 0:
		collector.destroy_item()
		heal(max_health/3)
	
	create_item(ItemData.ItemTypes.WHEAT, Vector2(randf_range(-1, 1), randf_range(0.6,1)))

func _process(delta: float) -> void:
	super(delta)
	_update_health(health - decay_rate * delta)
