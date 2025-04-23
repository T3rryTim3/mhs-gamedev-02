extends Node2D
class_name Main

@onready var settings = $CanvasLayer/Settings

var ui_hover_sound:AudioStreamPlayer
var ui_click_sound:AudioStreamPlayer

enum Scenes {
	MENU,
	LEVEL_SELECT,
	LEVEL_FIELD,
	LEVEL_TUTORIAL,
	PAUSE
}

func get_all(node: Node):
	var all_children := []
	for child in node.get_children():
		all_children.append(child)
		for grandchild in get_all(child):
			all_children.append(grandchild)
	return all_children

func _connect_ui_sound(node:Node): ## Adds UI interact sounds to the passed node.
	if !(node is Control):
		return
	if node is Button:
		node.mouse_entered.connect(ui_hover_sound.play)
		node.button_down.connect(ui_click_sound.play)

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
	
	# Load UI sounds
	ui_hover_sound = AudioStreamPlayer.new()
	ui_hover_sound.stream = load("res://Audio/SFX/Other/uiHover.wav")
	ui_hover_sound.volume_db -= 10
	add_child(ui_hover_sound)

	ui_click_sound = AudioStreamPlayer.new()
	ui_click_sound.stream = load("res://Audio/SFX/Other/UI Select.wav")
	add_child(ui_click_sound)

	for child in get_all(self):
		_connect_ui_sound(child)

	get_tree().connect("node_added", _connect_ui_sound) # Type checking is done within fucntion
	#child_entered_tree.connect(func(): print("NEW ONE 11"))

func _pause():
	_load_scene(Scenes.PAUSE)
	print(get_tree().current_scene)
