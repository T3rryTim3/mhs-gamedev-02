extends Control

@onready var you_died = $MarginContainer/AnimatedSprite2D

func _get_main() -> Main:
	if !(get_tree().current_scene is Main):
		print("ERROR: Main scene not found")
	return get_tree().current_scene

func _ready() -> void:
	visible = false

func _on_quit_pressed() -> void:
	_get_main()._load_scene(Main.Scenes.MENU)
	
	
