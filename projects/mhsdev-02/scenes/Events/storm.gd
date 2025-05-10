extends Event

@onready var lightning = preload("res://scenes/Events/LightningStrike.tscn")

var strike_delay:float = 0
var strike_damage:float = 2

var max_delay:float = 0.5

enum StormMode {
	RANDOM,
	TARGET
}

var current_mode:StormMode
var mode_cooldown:float = 4
var current_mode_cooldown = 0

var dying:bool = false

func _pick_random_pos() -> Vector2: ## Get a random position on the map
	var x = randi_range(-0.5*level.map_limit.shape.get_rect().size.x,0.5*level.map_limit.shape.get_rect().size.x)
	var y = randi_range(-0.5*level.map_limit.shape.get_rect().size.y,0.5*level.map_limit.shape.get_rect().size.y)
	return Vector2(x,y)

## Strike lightning at a random area on the map.
func _strike():
	var new = lightning.instantiate()
	new.data = data
	add_child(new)

	if current_mode == StormMode.RANDOM:
		new.global_position = _pick_random_pos() ## Assume the map is centered
	elif current_mode == StormMode.TARGET:
		new.global_position = _get_player().global_position + Vector2(randi_range(-100, 100), randi_range(-100, 100)) + _get_player().velocity

func _process(delta:float):
	super(delta)
	if dying:
		var lightning_children:Array
		for child in get_children():
			if child is Area2D:
				lightning_children.append(child)
		if len(lightning_children) == 0:
			queue_free()
		return

	# Update delay and mode
	current_mode_cooldown += delta
	if current_mode_cooldown >= current_mode:
		current_mode_cooldown = 0
		current_mode = [StormMode.RANDOM, StormMode.TARGET].pick_random()
	strike_delay += delta

	# Determine the amount of strikes
	if strike_delay >= max_delay:
		strike_delay = 0 + randf_range(-max_delay/4,max_delay/4) # Add random spacing between strikes
		if randi() % 2 == 0:
			_strike()
		elif randi() % 2 == 0:
			_strike()
			_strike()
		else:
			_strike()
			strike_delay = min(strike_delay, max_delay - 0.25)

func kill(): ## Called after event duration
	dying = true

func _ready():
	current_mode = StormMode.TARGET
	level = _get_level()
	max_delay = 1 / (EventMan.scale_val(data.strength) * 0.5)
