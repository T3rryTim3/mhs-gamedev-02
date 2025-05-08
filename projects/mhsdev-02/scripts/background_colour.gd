extends ColorRect

var target_color:Color

func _process(delta:float):
	color = color.lerp(target_color, 3 * delta)
