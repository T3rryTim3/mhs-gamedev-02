extends Station

@onready var collector_wheat = $Collector
@onready var collector_wood = $Collector2

var pickup_timer:Timer

func _ready():
	super()
	pickup_timer = Timer.new()
	pickup_timer.wait_time = 0.5
	pickup_timer.one_shot = false
	
	add_child(pickup_timer)
	
	pickup_timer.connect("timeout", collector_wheat.add_nearest_item)
	pickup_timer.connect("timeout", collector_wood.add_nearest_item)
	pickup_timer.start()

func produce():
	super()
	
	if (len(collector_wheat.current_resources) > 0) and (len(collector_wood.current_resources) > 0):
		collector_wheat.destroy_item()
		collector_wood.destroy_item()
	
		var new_drop:Item = drop.instantiate()
		new_drop.id = new_drop.ItemTypes.BREAD
		new_drop.position = $DropPos.position
		new_drop.apply_force(Vector3(randi_range(-60,-60),randi_range(60,130),0))
		
		get_parent().add_child.call_deferred(new_drop)
