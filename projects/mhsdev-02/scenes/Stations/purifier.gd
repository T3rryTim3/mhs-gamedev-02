extends Station

@onready var collector = $Collector

@onready var sprite_off = preload("res://images/stations/purifier_off.png")
@onready var sprite_on = preload("res://images/stations/purifier_on.png")

var pickup_timer:Timer

func _can_smelt():
	return len(collector.current_resources) > 0

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
	collector.connect("item_collected", _update_sprite)
	collector.connect("item_reset", _update_sprite)
	progress_timer.stop()
	progress_timer.one_shot = true

func produce():
	super()
	
	if _can_smelt():
		collector.destroy_item()
	
		create_item(ItemData.ItemTypes.WATER_CLEAN, Vector2(randf_range(-1,1), 1))

	_update_sprite()
