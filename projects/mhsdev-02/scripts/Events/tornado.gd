extends Event
class_name EventTornado

@onready var tornado_body = $Tornado/Body
@onready var tornado = $Tornado
@onready var sprite = $Tornado/Body/AnimatedSprite2D
@onready var collider = $Tornado/Body/Collision

# Base fling strength of tornado
var push_strength:int = 100
var push_damage:float = 3

# Cooldown for tornado movement
var move_cooldown:float = 5
var current_cooldown:float = 0
var cooldown_delay:float = 1

# Current target position for the tornado
var target_dir:Vector2 = Vector2.ZERO
var start_pos:Vector2 = Vector2.ZERO

func fling(body:PhysicsBody2D):
	if body is not Entity:
		return
	var dir = collider.global_position.direction_to(body.global_position)
	body.apply_force(Vector2(dir.x*push_strength,dir.y*push_strength))
	body.damage(push_damage)

func _get_random_direction(offset_max:float = PI/4):
	# Get the direction toward the player with a random offset
	return tornado_body.global_position.direction_to(_get_player().global_position).rotated(randf_range(-offset_max, offset_max))

func _select_target():
	start_pos = tornado_body.global_position
	target_dir = _get_random_direction()

func _process(delta):
	current_cooldown += delta
	if current_cooldown >= move_cooldown + cooldown_delay:
		_select_target()
		current_cooldown = 0
	
	if current_cooldown < move_cooldown: # Don't move during cooldown period
		tornado_body.velocity = target_dir * 100 * EventMan.scale_val(data.strength)
		tornado_body.move_and_slide()

func _ready() -> void:
	# Set default stats and connections
	collider.connect("body_entered", fling)
	push_strength = EventMan.scale_val(data.strength) * 300 # Use scale_val for logarithmic growthsss
	tornado.scale = _double_vec2(EventMan.scale_val(data.strength) * 2)
	move_cooldown = 2 / 1
	cooldown_delay = 1 / data.strength
	push_damage = 3 * EventMan.scale_val(data.strength)
	_select_target()
	sprite.play() # Tornado animation
	
