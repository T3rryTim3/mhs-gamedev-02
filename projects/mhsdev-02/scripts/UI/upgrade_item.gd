extends PanelContainer

var data:Dictionary = {} : set = set_state

func set_state(new):
	data = new
	$HBoxContainer2/TextureRect.texture = load(data["icon"])
	$HBoxContainer2/Label.text = data["desc"]
