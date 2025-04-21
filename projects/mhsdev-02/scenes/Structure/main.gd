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

func _load_scene(scene:Scenes, level_mode:Config.GameDifficulties=Config.GameDifficulties.FIELD_STANDARD):
	var new_scene
	for child in $LoadedScene.get_children():
		child.queue_free()
	match scene:
		Scenes.MENU:
			new_scene = load("res://scenes/UI/MainMenu.tscn").instantiate()
		Scenes.LEVEL_SELECT:
			new_scene = load("res://scenes/UI/select.tscn").instantiate()
		Scenes.LEVEL_FIELD:
			new_scene = load("res://scenes/Levels/field.tscn").instantiate()
		Scenes.LEVEL_TUTORIAL:
			new_scene = load("res://scenes/Levels/tutorial.tscn").instantiate()
		Scenes.PAUSE:
			new_scene = load("res://scenes/UI/PauseMenu.tscn").instantiate()
		_:
			print("ERROR: SCENE NOT FOUND")
			return
	if new_scene is Level:
		new_scene.level_data = Config.get_difficulty_level_data(level_mode)
	$LoadedScene.add_child(new_scene)
	Globals.current_level = scene

func _ready() -> void:
	Globals.main = self
	_load_scene(Scenes.MENU)
	print(get_tree().current_scene)
	

		
func _pause():
	_load_scene(Scenes.PAUSE)
	print(get_tree().current_scene)
