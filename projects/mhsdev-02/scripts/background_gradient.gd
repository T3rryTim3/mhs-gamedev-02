extends TextureRect

var target_color:Color

func _process(delta:float):
	modulate = modulate.lerp(target_color, 3 * delta)
