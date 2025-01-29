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

func _animate(): ## Animate the sprite
	if sprite is not AnimatedSprite2D:
		return
	
	var anim_name = "idle_down"
	
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
	
	if holding_item:
		anim_name += "_holding"
	
	sprite.play(anim_name)
	
func _process(delta) -> void:
	super(delta)
	_animate()

func _movement(delta):
	super(delta)
