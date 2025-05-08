extends Event
class_name EventVolcano

## Fireball
@onready var fireball_scn = preload("res://scenes/Events/fireball.tscn")

## Cooldown before fireball
var cooldown:float = 1

## Current cooldown
var current_cooldown:float = 0

## Fires a fireball in a random direction
func _fire():
	var ball:CharacterBody2D = fireball_scn.instantiate()
	var rand_val:float = randf()*PI*2
	var dir = Vector2(cos(rand_val),sin(rand_val))
	ball.rotation = rand_val
	ball.velocity = dir * EventMan.scale_val(data.strength) * 200
	ball.global_position = $StaticBody2D/pos.global_position
	ball.scale = _double_vec2(2 + EventMan.scale_val(data.strength)/2)
	ball.damage = 0.1 * EventMan.scale_val(data.strength)
	ball.push_strength = EventMan.scale_val(data.strength/2) * 100
	_get_level().map.add_child(ball)

func _ready():
	data.strength = 1
	cooldown = 2.5 / EventMan.scale_val(data.strength)
	
	# Spawn in any position at a set distance from the center of the map.
	var angle = randf_range(0, 2*PI)
	var map_shape = _get_level().map_limit.shape
	var lim = min(map_shape.get_rect().size.y/2, map_shape.get_rect().size.x/2)
	lim -= $StaticBody2D/Sprite2D.texture.get_size().y/2
	$StaticBody2D.global_position = map_shape.get_rect().get_center() + lim * Vector2(cos(angle), sin(angle))
	$StaticBody2D/Spawn.play()

func _process(delta: float) -> void:
	super(delta)

	# Shoot if cooldown reached
	current_cooldown += delta
	if current_cooldown >= cooldown:
		current_cooldown = 0
		$StaticBody2D/Erupt.play()
		Globals.level.player.camera.add_trauma(0.4)
		for x in range(10):
			_fire()
