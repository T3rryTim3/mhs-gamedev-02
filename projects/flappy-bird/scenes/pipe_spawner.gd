extends Node
class_name PipeSpawner

const pipe_template:PackedScene = preload("res://scenes/pipe.tscn")

@export var speed:int = 300
@export var rate:float = 2
@export var gap:int = 200
@export var camera:Camera2D

var spawn_timer:Timer

func _spawn_pipe():
	"""Spawn a set of pipes from the right."""

	var viewport_rect = get_viewport().get_visible_rect()
	var gap_pos = randf_range(viewport_rect.size.y/2-(gap/2.0), -viewport_rect.size.y/2+(gap/2.0))

	# Create bottom pipe
	var bottom_pipe = pipe_template.instantiate()
	add_child(bottom_pipe)
	var pipe_height = (bottom_pipe.pipe_height/4)*bottom_pipe.template.scale.y

	bottom_pipe.speed = speed
	bottom_pipe.global_position.x = viewport_rect.size.x/2 + bottom_pipe.pipe_width
	bottom_pipe.length = 10

	bottom_pipe.global_position.y = viewport_rect.size.y/2 + (pipe_height*bottom_pipe.length)
	bottom_pipe.global_position.y -= -(gap_pos - viewport_rect.size.y/2)

	bottom_pipe._draw_pipe()

	# Create top pipe
	var top_pipe = pipe_template.instantiate()
	add_child(top_pipe)
	top_pipe.speed = speed
	top_pipe.global_position.x = viewport_rect.size.x/2 + top_pipe.pipe_width
	top_pipe.length = 10

	top_pipe.rotation = PI
	top_pipe.global_position.y = bottom_pipe.global_position.y - (2*pipe_height*bottom_pipe.length) - gap

	top_pipe._draw_pipe()


func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = rate
	spawn_timer.timeout.connect(_spawn_pipe)
	add_child(spawn_timer)
	spawn_timer.start()
