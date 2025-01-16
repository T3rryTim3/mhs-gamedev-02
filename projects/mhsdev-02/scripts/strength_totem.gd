extends Station
class_name StrengthTotem

@onready var collector:Collector = $Collector

func produce():
	super()
	if collector.item_count() > 0:
		collector.destroy_item()
		active = true
	else:
		active = false
	
