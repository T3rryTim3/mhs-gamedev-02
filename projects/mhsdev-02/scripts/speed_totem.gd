extends Station
class_name SpeedTotem

@onready var collector:Collector = $Collector

var pos:float = 0

func _ready() -> void:
	super()
	sprite.texture = load("res://images/stations/Speed Totem (on).png")

func produce():
	super()
	if collector.item_count() > 0:
		collector.destroy_item()
		active = true
		$Sprite2D/PointLight2D.enabled = true
		sprite.texture = load("res://images/stations/Speed Totem (on).png")
	else:
		active = false
		sprite.position.y = 0
		$Sprite2D/PointLight2D.enabled = false
		sprite.texture = load("res://images/stations/Speed Totem (off).png")
	_get_level().update_station_stats()

func _on_collector_item_collected() -> void:
	if not active:
		progress_timer.stop()
		progress_timer.start()
		produce()

func _process(delta: float) -> void:
	super(delta)
	if active:
		pos = fposmod(pos+delta, 2*PI)
		sprite.position.y = 2*sin(pos)
