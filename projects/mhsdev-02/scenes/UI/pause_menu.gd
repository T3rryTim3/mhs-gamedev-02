extends Control

@onready var resume = $Panel/MarginContainer/VBoxContainer/Resume
@onready var quit = $Panel/MarginContainer/VBoxContainer/Quit

func _get_main() -> Main:
	if !(get_tree().current_scene is Main):
		print("ERROR: Main scene not found")
	return get_tree().current_scene

func _unpause():
	Globals.main.music_man.lp_toggle = false
	get_tree().paused = false
	visible = false

func _pause():
	Globals.main.music_man.lp_toggle = true
	get_tree().paused = true
	visible = true

func _input(event: InputEvent) -> void:
	if event.is_action("pause"):
		_pause()

func _ready() -> void:
	visible = false
	resume.pressed.connect(_unpause)

func _on_settings_pressed() -> void:
	Globals.main.show_settings()

func _on_quit_pressed() -> void:
	_get_main()._load_scene(Main.Scenes.MENU)


func _on_achievements_pressed() -> void:
	Globals.main.show_achievements()
