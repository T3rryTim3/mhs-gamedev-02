extends PanelContainer

func load_achievement(achievement):
	#print(Achievements.current)
	$MarginContainer/HSplitContainer/LabelBox/Label.text = Achievements.data[achievement]["name"]
	$MarginContainer/HSplitContainer/LabelBox/Label2.text = Achievements.data[achievement]["desc"]
	$MarginContainer/HSplitContainer/MarginContainer/TextureRect.texture = load(Achievements.data[achievement]["icon"])
	$MarginContainer/HSplitContainer/LabelBox/ProgressBar.max_value = Achievements.data[achievement]["max"]
	if Achievements.current.has(achievement):
		#print("FOUND AN ACHIEVEMENT")
		#print(achievement)
		#print(Achievements.current)
		$MarginContainer/HSplitContainer/LabelBox/ProgressBar.value = Achievements.current[achievement]
	else:
		$MarginContainer/HSplitContainer/LabelBox/ProgressBar.value = 0
