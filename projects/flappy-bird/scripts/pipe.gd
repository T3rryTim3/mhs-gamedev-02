extends MovingObject

@onready var template = $Template
@onready var model = $Model
@onready var collider = $CollisionShape2D

var pipe_width:int = 0
var pipe_height:int = 0

@export var length:int = 2 # Must be 1 or greater.
@export_range(0,3)
var style:int = 0

func _draw_pipe():
	"""Draw the pipe segment by segment. Assumes a 4x4 tile grid is provided."""
	for i in range(length):
		var segment = template.duplicate()

		# Set texture to cap or middle based on segment
		if i + 1 == length:
			segment.frame = style
		else:
			segment.frame = style + 4

		# Add offset based on pipe size
		segment.position.y -= i * (template.texture.get_height() * template.scale.y / 4)

		model.add_child(segment)

	# Set collision
	collider.scale.y = length
	collider.position.y = (length * (template.texture.get_height() * template.scale.y / 4)) / -2

func _ready() -> void:
	pipe_width = template.texture.get_width()
	pipe_height = template.texture.get_height()
	for child in model.get_children():
		child.queue_free()
	#_draw_pipe()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("Outta here!")
	queue_free()
