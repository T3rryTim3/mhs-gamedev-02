extends CharacterBody2D
class_name Entity
## Base entity class for all objects in the game.
## Includes characters, items etc.
##
## Can be influenced by other entities with the coefficient of 'move_influence'

## Called when force is applied to the entity
signal force_applied

## Sprite of the entity.
@export var sprite:Node2D

## Health of the object. calls '_death' upon hitting zero.
@export var health:float = 10

## Coefficient of any movement force applied on the object.
@export var move_influence:float = 1.0

## Healthbar scale relative to sprite width
@export var health_bar_scale:float = 1

## Healthbar placement offset (Starting from bottom-center of the sprite)
@export var health_bar_offset:Vector2 = Vector2.ZERO

## Health bar
var health_bar:StatBar

## Healthbar scene to be instantiated
var stat_bar = preload("res://scenes/Base/health_bar.tscn")

## Current force applied on the object. 'z' corresponds to the visual height of the entity.
var force:Vector3 = Vector3.ZERO

## Height off of the ground - Only affects sprite visual
var height:float = 0

## Current velocity of height
var height_vel:float = 0

## Speed of force reduction (per second)
var drag:float = 500

## Max health - auto set to 'health' start value
var max_health:float

## Force / Gravity constants
const GRAVITY:int = 30
const MAX_VEL:Vector3 = Vector3(100,100,100)

## Hide the healthbar - Used when items are collected
var show_health:bool = true

func _get_level(): 
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

func _get_sprite_texture() -> Texture2D:
	if sprite is Sprite2D:
		return sprite.texture
	if sprite is AnimatedSprite2D:
		return sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
	print("ERROR: INVALID SRPITE SET")
	return Texture.new()

func _update_health(new:float) -> void: ## Update health while keeping within limits.
	health = clamp(new, 0, max_health)
	if health <= 0:
		_death()

func _ready():
	# Set max health to current value
	max_health = health

	var sprite_texture = _get_sprite_texture()

	# Instantiate health bar
	health_bar = stat_bar.instantiate()
	health_bar.texture_width = sprite_texture.get_width() * sprite.scale.x
	health_bar.texture_height = sprite_texture.get_height() * sprite.scale.y

	health_bar.thickness = 0.15

	health_bar.position.y = (sprite_texture.get_height()/2.0)*sprite.scale.y
	health_bar.position += health_bar_offset

	health_bar.size_scale = health_bar_scale

	add_child(health_bar)

func _death() -> void: ## Calls upon health hitting zero. Will queue free by default.
	queue_free()

func _update_force(delta) -> void: ## Updates the velocity of the entity (According to move_influence)

	# Apply force
	if abs(force.z) > 0:
		height_vel = force.z
	else:
		height_vel -= GRAVITY * delta

	if height <= 0 and height_vel <= 0:
		height_vel = 0

	height = max(0, height + height_vel)
	velocity += Vector2(force.x,force.y)

	sprite.position.y = -height # Update relative sprite position

	force = force.move_toward(Vector3.ZERO, drag * delta)
	force.z = 0

func _movement(_delta) -> void: ## Used in subclasses for movement
	pass

func _process(_delta):
	health_bar.visible = show_health
	return

func _round_vector(vec:Vector2, n:int) -> Vector2: ## Rounds each value of vec to n
	return Vector2(int(vec.x/n)*n, int(vec.y/n)*n)

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO

	#if Input.is_action_just_pressed("ui_accept"):
		#apply_force(Vector3(randf_range(-1,1)*600,randf_range(-1,1)*600,randf_range(0,1)*600))

	health_bar.current = health/max_health

	_movement(delta)
	_update_force(delta)
	move_and_slide()

func damage(_amount:float, _kb:Vector3=Vector3.ZERO) -> void: # Deal damage to the entity
	pass

func heal(amount:float) -> void:
	health = clampf(health + amount, 0, max_health)

func apply_force(applied:Vector2): ## Apply force to the entity
	var new_applied:Vector3 = Vector3(applied.x, applied.y, 0)
	new_applied *= move_influence
	new_applied.z = (abs(applied.y) + abs(applied.x)) / 80
	force += new_applied
	
	if applied.length() > 0:
		force_applied.emit()
