extends CharacterBody2D

var damage:float
var push_strength:float
var hit_bodies:Array
var time:float

func _on_collider_body_entered(body: Node2D) -> void:
	if body is Entity:
		if body in hit_bodies:
			return
		hit_bodies.append(body)
		var dir = velocity.normalized()
		body.apply_force(Vector2(dir.x*push_strength,dir.y*push_strength))
		body.damage(damage)
		body.add_effect(EffectData.EffectTypes.BURNING, 10, 0.5)
	

func _process(delta: float) -> void:
	time += delta
	if time > 10:
		queue_free()
	move_and_slide()
