extends StaticBody2D
class_name MovingObject

@export var speed:int = 300
@export var direction:Vector2 = Vector2.LEFT
@export var deadly:bool = true

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
