extends CharacterBody2D

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer:Timer = $Timers/Dash
@onready var dashing:Timer = $Timers/Dashing

@export var speed:int = 550
@export var acceleration:float = 0.35
@export var jump_speed:int = -1100
@export var gravity:int = 3500
@export var dash_time:float = 0.4
@export var dash_speed_multi:float = 3
@export var dash_cooldown:float = 2

var move_direction:float = 0

func _ready() -> void:
	dash_timer.wait_time = dash_cooldown
	dashing.wait_time = dash_time

func handle_animations():
	"""Handle movement animations"""
	
	var anim = sprite.animation
	
	if not dashing.is_stopped():
		sprite.pause()
	
	if abs(velocity.x) >= 18:
		sprite.flip_h = (velocity.x < 0)
		sprite.speed_scale = velocity.x / 700
		anim = "Run"
	elif false: #TODO: Jump animation
		pass
	else:
		sprite.speed_scale = 0.5
		anim = "Idle"
	
	if sprite.animation != anim:
		sprite.stop()
		sprite.play(anim)

func _physics_process(delta: float) -> void:
	
	# Movement + Dash logic
	move_direction = Input.get_axis("left","right") # Don't set direction if dashing
	var move_speed:float = move_direction * speed
	var current_gravity = gravity * delta
	
	# Change speed based on dash
	move_speed = lerp(move_speed, move_speed * dash_speed_multi, dashing.time_left/dashing.wait_time)
	velocity.x = lerpf(velocity.x, move_speed, acceleration)
	
	# Update gravity (Decrease if dashing)
	current_gravity = lerpf(current_gravity, current_gravity/2, dashing.time_left/dashing.wait_time)
	velocity.y += current_gravity
	
	# Jump, if able
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
	
	# Handle dash timer
	elif Input.is_action_just_pressed("dash") and dash_timer.is_stopped() and dashing.is_stopped():
		dash_timer.start()
		dashing.start()

	# Update
	handle_animations()
	move_and_slide()

func _on_dashing_timeout() -> void:
	sprite.play()
