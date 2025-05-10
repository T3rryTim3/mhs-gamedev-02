extends Camera2D

var camera_mouse_offset:Vector2
var camera_shake_offset:Vector2

@export var decay = 0.95  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3]

func add_trauma(amount):
	trauma = min(trauma + amount, 0.6)

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	camera_shake_offset.x = max_offset.x * amount * randf_range(-1, 1)
	camera_shake_offset.y = max_offset.y * amount * randf_range(-1, 1)

func _process(delta: float) -> void:
	# Lerp camera towards the mouse
	var distance = min(100, Vector2.ZERO.distance_to(get_local_mouse_position())) / 2
	var mouse_offset = Vector2.ZERO.direction_to(get_local_mouse_position())
	camera_mouse_offset = camera_mouse_offset.lerp(mouse_offset * distance, 10 * delta)

	# Add screen shake
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

	offset = camera_mouse_offset + camera_shake_offset
