extends Label

var target_color:Color
var target_outline:Color
var color:Color = Color(1,1,1)
var outline:Color = Color("000000")

func _process(delta:float):
	color = color.lerp(target_color, 3*delta)
	outline = outline.lerp(target_outline, 3*delta)
	add_theme_color_override("font_color", color)
	add_theme_color_override("font_outline_color", outline)
