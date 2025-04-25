extends PanelContainer

@onready var panel_object = preload("res://panel_container.tscn")

func _on_button_pressed() -> void:
	visible = false

func _load_achievements() -> void:
	for child in $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	var achievements = {
		1: {
			"name": "Addict",
			"desc": "Beat the game 10 times",
			"icon": "",
			"max": 10
		}
	}
	var current = {
		1: 3
	}
	for k in achievements:
		var new_panel = panel_object.instantiate()
		new_panel.load_achievement(achievements[k], current)
		$MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.add_child(new_panel)

func _ready():
	_load_achievements()
