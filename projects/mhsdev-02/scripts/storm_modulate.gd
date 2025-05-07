extends CanvasModulate

var enabled:bool = false

var speed:float = 0.25

var goal:Color = Color(1,1,1,1)

func _process(delta: float) -> void:
	color = color.lerp(goal, 0.25 * delta)
