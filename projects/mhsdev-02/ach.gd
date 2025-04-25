extends PanelContainer

func load_achievement(data, current):
	$MarginContainer/HSplitContainer/LabelBox/Label.text = data["name"]
	$MarginContainer/HSplitContainer/LabelBox/Label2.text = data["desc"]
