extends Control

@onready var resume = $MarginContainer/VBoxContainer/Resume
@onready var quit = $MarginContainer/VBoxContainer/Quit
@onready var menu = %Settings
@onready var title = %Titlescreen

func _input(event: InputEvent) -> void:
	if event.is_action("pause"):
		_pause()

func _pause():
	visible = true

func _unpause():
	visible = false

func _ready() -> void:
	visible = false
	menu.visible = false
	resume.pressed.connect(_unpause)

func _on_settings_pressed() -> void:
	menu.visible = true

func _on_quit_pressed() -> void:
	title.visible = true
	visible = false
