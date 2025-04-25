extends PanelContainer

var data:Dictionary = {} : set = set_state
@onready var button = $Button

var target_scale:float = 1

func set_state(new):
	data = new
	$TextureRect.texture = load(data["icon"])

func _process(delta: float) -> void:
	scale.y = lerpf(scale.y, target_scale, 4*delta)
	scale.x = lerpf(scale.x, target_scale, 4*delta)

func _on_button_mouse_entered() -> void:
	target_scale = 1.2

func _on_button_mouse_exited() -> void:
	target_scale = 1
