extends Node2D
class_name Main

@onready var settings = $CanvasLayer/Settings

enum Scenes {
	MENU,
	LEVEL_SELECT,
	LEVEL_FIELD,
	LEVEL_TUTORIAL,
	PAUSE
}

func show_settings():
	settings.show()

func _load_scene(scene:Scenes):
	for child in $LoadedScene.get_children():
		child.queue_free()
	match scene:
		Scenes.MENU:
			$LoadedScene.add_child(load("res://scenes/UI/MainMenu.tscn").instantiate())
		Scenes.LEVEL_SELECT:
			$LoadedScene.add_child(load("res://scenes/UI/select.tscn").instantiate())
		Scenes.LEVEL_FIELD:
			$LoadedScene.add_child(load("res://scenes/Levels/field.tscn").instantiate())
		Scenes.LEVEL_TUTORIAL:
			$LoadedScene.add_child(load("res://scenes/Levels/tutorial.tscn").instantiate())
		Scenes.PAUSE:
			$LoadedScene.add_child(load("res://scenes/UI/PauseMenu.tscn").instantiate())

func _ready() -> void:
	_load_scene(Scenes.MENU)
	print(get_tree().current_scene)
	

		
func _pause():
	_load_scene(Scenes.PAUSE)
	print(get_tree().current_scene)
