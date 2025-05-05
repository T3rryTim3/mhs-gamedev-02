extends Event

@onready var lightning = preload("res://scenes/Events/LightningStrike.tscn")

var strike_delay:float = 0
var strike_damage:float = 2

var max_delay:float = 2

## Strike lightning at a random area on the map.
func _strike():
	var new = lightning.instantiate()
	new.data = data
	add_child(new)
	var x = randi_range(-0.5*level.map_limit.shape.get_rect().size.x,0.5*level.map_limit.shape.get_rect().size.x)
	var y = randi_range(-0.5*level.map_limit.shape.get_rect().size.y,0.5*level.map_limit.shape.get_rect().size.y)
	new.global_position = Vector2(x,y) ## Assume the map is centered

func _process(delta:float):
	strike_delay += delta
	if strike_delay >= max_delay:
		_strike()
		strike_delay = 0

func _ready():
	strike_delay = 20 / EventMan.scale_val(data.strength)
