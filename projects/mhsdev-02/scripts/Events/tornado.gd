extends Event
class_name EventTornado

@onready var tornado_body = $Tornado/Body
@onready var tornado = $Tornado
@onready var sprite:AnimatedSprite2D = $Tornado/Body/AnimatedSprite2D
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

# Used for the x offset
var x_progress:float = 0

func fling(body):
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

func _physics_process(delta: float) -> void:
	x_progress += delta * 6
	_get_player().velocity
	current_cooldown += delta
	if tornado_body.global_position.distance_to(_get_player().global_position) > 400:
		current_cooldown = move_cooldown + cooldown_delay # Dont wait if player is far
	if current_cooldown >= move_cooldown + cooldown_delay:
		_select_target()
		current_cooldown = 0

	tornado_body.velocity.x = cos(x_progress) * 90
	tornado_body.velocity.y = 0
	if current_cooldown < move_cooldown: # Don't move during cooldown period
		tornado_body.velocity += target_dir * 100 * EventMan.scale_val(data.strength)
	tornado_body.move_and_slide()

func _process(delta):
	# Fade out when ending
	super(delta)
	if data.duration - alive_dur < 1:
		$Tornado.modulate.a = (data.duration - alive_dur)

func _ready() -> void:
	# Set default stats and connections
	collider.connect("body_entered", fling)
	push_strength = EventMan.scale_val(data.strength/2) * 300 # Use scale_val for logarithmic growth
	tornado.scale = _double_vec2(EventMan.scale_val(data.strength) * 2)
	move_cooldown = 2.0
	cooldown_delay = 0 / data.strength
	push_damage = 2.5 * EventMan.scale_val(data.strength)
	_select_target()
	sprite.play() # Tornado animation
	$Tornado/Body/Sound.play()
	
	# Set position to outside of the map
	var lim:CollisionShape2D = _get_level().map_limit
	var pos = lim.global_position
	var texture = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
	
	# Random left or right
	if randi_range(1,2) % 2 == 0:
		pos.x += lim.shape.get_rect().size.x/2 + tornado.scale.x * texture.get_size().x * 0.5
	else:
		pos.x -= lim.shape.get_rect().size.x/2 - tornado.scale.x * texture.get_size().x * 0.5
	
	# Y-offset
	pos.y += randf_range(lim.shape.get_rect().size.y/-2,lim.shape.get_rect().size.y/2 )
	
	tornado.global_position = pos
	
