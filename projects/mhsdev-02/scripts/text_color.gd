extends Label

var target_color:Color
var color:Color = Color(1,1,1)

func _process(delta:float):
	color = color.lerp(target_color, 3*delta)
	add_theme_color_override("font_color", color)
