extends Control


@onready var menu = $smenu
@onready var credits = $cmenu

func _ready() -> void:
	menu.visible = false
	credits.visible = false

func _on_button_pressed() -> void:
	get_tree().quit()


func _on_button_2_pressed() -> void:
	menu.visible = true
	


func _on_exit_pressed() -> void:
	menu.visible =  false



func _on_credits_pressed() -> void:
	credits.visible = true



func _on_back_pressed() -> void:
	credits.visible = false
