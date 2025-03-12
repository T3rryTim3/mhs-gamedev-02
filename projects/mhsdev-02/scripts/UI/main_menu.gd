extends Control


@onready var menu = $Settings


func _ready() -> void:
	menu.visible = false

func _on_button_pressed() -> void:
	get_tree().quit()


func _on_button_2_pressed() -> void:
	menu.visible = true
	
