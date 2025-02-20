extends Station
class_name Campfire

@onready var fire_area:Area2D = $Area2D

func _ready() -> void:
	super()
	progress_timer.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.state.temp.set_drain_factor('campfire', true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.state.temp.set_drain_factor('campfire', false)
