extends PanelContainer

@onready var panel_object = preload("res://panel_container.tscn")
@onready var progress = get_node("res://panel_container.tscn")


func _on_button_pressed() -> void:
	visible = false

func _load_achievements() -> void:
	for child in $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	const data = preload("res://scripts/Singletons/achievements.gd")
	
	var current = {
		1: 3
	}
	
	for k in data:
		var new_panel = panel_object.instantiate()
		new_panel.load_achievement(data[k], current[k])
		$MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.add_child(new_panel)


func _ready():
	_load_achievements()
