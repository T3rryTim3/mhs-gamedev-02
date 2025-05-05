extends PanelContainer

@onready var panel_object = preload("res://achievementitem.tscn")

func _on_button_pressed() -> void:
	visible = false

func _load_achievements() -> void:
	for child in $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()

	print("LOADING MENU")
	#print(Achievements.current)
	for k in Achievements.data:
		#print(k)
		var new_panel = panel_object.instantiate()
		new_panel.load_achievement(k)
		$MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.add_child(new_panel)

func _ready():
	_load_achievements()
