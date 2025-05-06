extends CanvasModulate

var enabled:bool = false

var progress:float = 0
var speed:float = 0.25

var goal:Color = Color(0.573, 0.531, 0.823, 1)

func _process(delta: float) -> void:
	if enabled:
		progress = min(1, progress + delta * speed)
	else:
		progress = max(0, progress - delta * speed)
	color = Color.WHITE.lerp(goal, progress)
