extends Control


@onready var menu = %Settings
@onready var start = $ScrollContainer/VBoxContainer/start
@onready var creds = $Credits_scene

func _ready() -> void:
	menu.visible = false
	creds.visible = false

func _on_start_pressed() -> void:
	visible = false

func _on_button_pressed() -> void:
	get_tree().quit()

func _on_button_2_pressed() -> void:
	menu.visible = true

func _on_credits_pressed() -> void:
	creds.visible = true
