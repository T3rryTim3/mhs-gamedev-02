extends CharacterBody2D

var damage:float
var push_strength:float
var hit_bodies:Array
var time:float
var max_time:float = 10
var fade_threshhold:float = 0.8

func player_hit():
	velocity = -0.5 * velocity
	time = max_time * fade_threshhold

func _on_collider_body_entered(body: Node2D) -> void:
	if body is Entity:
		if body in hit_bodies:
			return
		hit_bodies.append(body)
		var dir = velocity.normalized()
		body.apply_force(Vector2(dir.x*push_strength,dir.y*push_strength))
		body.damage(damage)
		body.add_effect(EffectData.EffectTypes.BURNING, 5, 0.5)
		if body is not Item:
			queue_free()

func _process(delta: float) -> void:
	time += delta
	if time > max_time * fade_threshhold: # Fade out past 80% finished
		modulate.a = ((max_time - time) / (max_time*(1 - fade_threshhold)))
	if time > max_time:
		queue_free()
	move_and_slide()
