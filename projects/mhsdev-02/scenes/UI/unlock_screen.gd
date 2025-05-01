extends PanelContainer

@onready var panel_object = preload("res://panel_container.tscn")

func _on_button_pressed() -> void:
	visible = false

func _load_achievements() -> void:
	for child in $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	
	
	var data = Achievements.get_data()
	
	if data.size() == 0:
		print("Achievements data is empty.")
		return
	
	var current = {}
	
	for k in data.keys():
		var new_panel = panel_object.instantiate()
		new_panel.load_achievement(data[k], current.get(k,0))
		$MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.add_child(new_panel)


func _ready():
	if Achievements:
		print(Achievements.get_data())
		_load_achievements()
	else:
		print("Achievements singleton not initialized properly.")
