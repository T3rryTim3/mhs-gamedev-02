extends Control

var menu
@onready var start = $VBoxContainer/start
@onready var creds = $Credits_scene

func _ready() -> void:
	visible = true
	menu = Globals.main
	menu.visible = false
	creds.visible = false

func _on_start_pressed() -> void:
	Globals.main._load_scene(Main.Scenes.LEVEL_SELECT)

func _on_button_pressed() -> void:
	get_tree().quit()

func _on_button_2_pressed() -> void:
	Globals.main.show_settings()

func _on_credits_pressed() -> void:
	creds.visible = true
