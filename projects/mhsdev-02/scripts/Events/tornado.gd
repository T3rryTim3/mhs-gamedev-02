extends Event
class_name EventTornado

@onready var tornado_body = $Body
@onready var sprite = $Body/AnimatedSprite2D
@onready var collider = $Collision

var push_strength:int = 100

func fling(body:PhysicsBody2D):
	if body is not Entity:
		return
	var dir = collider.global_position.direction_to(body.global_position)
	body.apply_force(Vector2(dir.x*push_strength,dir.y*push_strength))

func _ready() -> void:
	collider.connect("body_entered", fling)
	push_strength = EventMan.scale_val(data.strength) * 300
	tornado_body.scale = _double_vec2(EventMan.scale_val(data.strength))
	collider.scale = _double_vec2(EventMan.scale_val(data.strength))
	sprite.play()
	
