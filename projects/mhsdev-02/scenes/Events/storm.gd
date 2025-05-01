extends Event

@onready var lightning = preload("res://scenes/Events/LightningStrike.tscn")

var strike_delay:float
var strike_damage:float

var max_delay:float

## Strike lightning at a random area on the map.
func _strike():
	pass

func _process(delta:float):
	strike_delay += delta
	if strike_delay >= max_delay:
		_strike()

func _ready():
	strike_delay = 20 / EventMan.scale_val(data.strength)
