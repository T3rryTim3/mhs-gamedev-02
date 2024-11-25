extends CharacterBody2D

@onready var sprite:Sprite2D = $Sprite2D
@onready var hitboc:Area2D = $Hitbox
@onready var anim_player:AnimationPlayer = $AnimationPlayer

@export var speed:int = 350
@export var maxvel:int = 600

func _end_game():
	print("end")
	queue_free()
	pass

func _physics_process(delta: float) -> void:

	velocity.y += speed * delta

	if Input.is_action_just_pressed("jump"):
		velocity.y = -speed
		anim_player.play("fly")

	velocity.y = clamp(velocity.y, -maxvel, maxvel) # Don't exceed max

	sprite.rotation = lerp(sprite.rotation, (velocity.y / maxvel) * (PI/2), 0.3)

	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	print(body)
	if body is MovingObject and (body.deadly == true):
		_end_game()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_end_game()
