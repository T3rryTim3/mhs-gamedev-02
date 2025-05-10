extends Station
class_name Campfire

@onready var fire_area:Area2D = $Area2D

var temp:float = 100
var temp_gain:float = 10

var past:bool

func _ready() -> void:
	super()
	progress_timer.stop()

func _freezing() -> bool:
	if temp < 10:
		return true
	return false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if not _freezing():
			body.state.temp.set_drain_factor('campfire', true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.state.temp.set_drain_factor('campfire', false)

func _process(delta):
	super(delta)
	modulate = Color(1,1,1).lerp(Color(1,1,10), 1-(temp/100))
	if _freezing():
		_update_health(health - (10 * delta)/max_health)
	else:
		temp += delta * temp_gain
	temp = clampf(temp,0,100)
	if not (past == _freezing()):
		sprite.texture = load("res://images/stations/campfire(off).png")
		for body in $Area2D.get_overlapping_bodies():
			if body is Player:
				body.state.temp.set_drain_factor('campfire', false)
	past = _freezing()
	
