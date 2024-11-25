extends ParallaxBackground

var cloud_speed:int = 10

func _process(delta: float) -> void:
	for child in get_children():
		if child is ParallaxLayer:
			child.motion_offset.x -= cloud_speed * child.motion_scale.x * delta
