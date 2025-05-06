extends Event

@onready var lightning = preload("res://scenes/Events/LightningStrike.tscn")

var strike_delay:float = 0
var strike_damage:float = 2

var max_delay:float = 0.5

func _pick_random_pos() -> Vector2: ## Get a random position on the map
	var x = randi_range(-0.5*level.map_limit.shape.get_rect().size.x,0.5*level.map_limit.shape.get_rect().size.x)
	var y = randi_range(-0.5*level.map_limit.shape.get_rect().size.y,0.5*level.map_limit.shape.get_rect().size.y)
	return Vector2(x,y)

## Strike lightning at a random area on the map.
func _strike():
	var new = lightning.instantiate()
	new.data = data
	add_child(new)

	new.global_position = _pick_random_pos() ## Assume the map is centered

func _process(delta:float):
	super(delta)
	strike_delay += delta
	if strike_delay >= max_delay:
		_strike()
		strike_delay = 0 + randf_range(-max_delay/4,max_delay/4) # Add random spacing between strikes

func _ready():
	level = _get_level()
	max_delay = 0.78 / EventMan.scale_val(data.strength)
