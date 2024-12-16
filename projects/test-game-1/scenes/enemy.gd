extends CharacterBody2D

@export var speed:int = 300
@export var jump_speed:int = -1100
@export var gravity:int = 3500
@export var aggro:int = 2000
@export var target:Node2D

var direction:float = 0

func _physics_process(delta: float) -> void:
	var distance = global_position.distance_to(target.global_position)
	
	if distance > aggro:
		return
	
	direction = global_position.direction_to(target.global_position).normalized().x
	
	velocity.x = direction * speed
	velocity.y += gravity * delta

	if is_on_floor() and target.global_position.y - global_position.y < -50:
		velocity.y = jump_speed
	
	move_and_slide()
