extends StaticBody2D

@onready var collider = $Area2D

var warning_time:float = 3
var size_scale:float = 1
var strike_damage:float = 8
var push_strength:float = 1

var data:EventMan.EventData

var current_progress:float = 0

func _process(delta: float) -> void:
	var old = current_progress
	current_progress += delta

	# When the warning is over
	if old < warning_time and current_progress >= warning_time:
		$AnimatedSprite2D.play("strike")
		$AnimatedSprite2D.animation_finished.connect(queue_free)
		for body in $Area2D.get_overlapping_bodies():
			if body is not Entity:
				return
			var dir = collider.global_position.direction_to(body.global_position).normalized()
			body.apply_force(Vector2(dir.x*push_strength,dir.y*push_strength))
			body.damage(strike_damage)

func _ready():
	push_strength = EventMan.scale_val(data.strength/2) * 300
	strike_damage = 1 * EventMan.scale_val(data.strength)
	scale = Vector2(EventMan.scale_val(data.strength) * 2,EventMan.scale_val(data.strength) * 2)
	$Spawn.play()
	$TextureRect.visible = true
	$GPUParticles2D.visible = true
