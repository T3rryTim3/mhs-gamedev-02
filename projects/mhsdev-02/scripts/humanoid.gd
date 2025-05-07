extends Entity
class_name Humanoid

## Walk speed
@export var move_speed = 100

## Last move direction
var last_move_dir:Vector2

## Current move direction
var move_dir:Vector2

## If the humanoid is holding an item or not (used for animation only)
var holding_item:bool = false

var attacking:bool = false

func _stop_attacking():
	attacking = false
	sprite.animation_finished.disconnect(_stop_attacking)

func _attack():
	if not attacking:
		attacking = true
		sprite.animation_finished.connect(_stop_attacking)
		var anim_name:String
		var dir = global_position.direction_to(get_global_mouse_position())
		var dot = dir.dot(Vector2(0,1)) # Find the dot product to calculate the direction of the swing
		#print(dot)
		if dir.x < 0 and -0.5 < dot and dot < 0.5:
			sprite.flip_h = true
			anim_name = "attack_left"
		elif dir.x > 0 and -0.5 < dot and dot < 0.5:
			anim_name = "attack_right"
		elif dir.y < 0 and -1 < dot and dot < -0.5:
			anim_name = "attack_up"
		elif dir.y > 0 and 0.5 < dot and dot < 1:
			anim_name = "attack_down"
		else:
			anim_name = "attack_down"
		sprite.play(anim_name)
		return true
	else:
		return false

func _animate(): ## Animate the sprite
	# Attack animation is handled in _attack()
	if attacking:
		return

	if sprite is not AnimatedSprite2D:
		return
	
	var anim_name = "idle_down"

	sprite.flip_h = false

	# Idle animation
	if move_dir == Vector2.ZERO:
		if last_move_dir.x < 0:
			anim_name = "idle_left"
		elif last_move_dir.x > 0:
			anim_name = "idle_right"
		elif last_move_dir.y < 0:
			anim_name = "idle_up"
		elif last_move_dir.y > 0:
			anim_name = "idle_down"
	
	# Movement animation
	else:
		if move_dir.x < 0:
			anim_name = "move_left"
		elif move_dir.x > 0:
			anim_name = "move_right"
		elif move_dir.y < 0:
			anim_name = "move_up"
		elif move_dir.y > 0:
			anim_name = "move_down"

	if holding_item and not attacking: # Second condition should never contradict, but its there to be safe.
		anim_name += "_holding"
	
	sprite.play(anim_name)
	
func _process(delta) -> void:
	super(delta)
	_animate()

func _movement(delta):
	super(delta)
