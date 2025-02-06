extends Station

@onready var collector_wheat = $Collector
@onready var collector_wood = $Collector2

@onready var sprite_off = preload("res://images/stations/oven(off).png")
@onready var sprite_on = preload("res://images/stations/oven(on).png")

var pickup_timer:Timer

func _can_smelt():
	return (len(collector_wheat.current_resources) > 0) and (len(collector_wood.current_resources) > 0)

func _update_sprite():
	if _can_smelt():
		sprite.texture = sprite_on
		if progress_timer.is_stopped():
			progress_timer.start()
			$PointLight2D.enabled = true
	else:
		sprite.texture = sprite_off
		progress_timer.stop()
		$PointLight2D.enabled = false

func _ready():
	super()
	collector_wheat.connect("item_collected", _update_sprite)
	collector_wood.connect("item_collected", _update_sprite)
	collector_wheat.connect("item_reset", _update_sprite)
	collector_wood.connect("item_reset", _update_sprite)
	progress_timer.stop()
	progress_timer.one_shot = true

func produce():
	super()
	
	if _can_smelt():
		collector_wheat.destroy_item()
		collector_wood.destroy_item()
	
		create_item(ItemData.ItemTypes.BREAD, Vector2(randf_range(-1,1), 1))

	_update_sprite()
