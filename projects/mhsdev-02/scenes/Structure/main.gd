extends Node2D
class_name Main

@onready var settings = $CanvasLayer/Settings
@onready var achievements = $CanvasLayer/Achievements
@onready var music_man:MusicMan = $MusicMan

var ui_hover_sound:AudioStreamPlayer
var ui_click_sound:AudioStreamPlayer

enum Scenes {
	MENU,
	LEVEL_SELECT,
	LEVEL_FIELD,
	LEVEL_TUTORIAL,
	LEVEL_TUNDRA,
	LEVEL_DESERT,
	PAUSE,
	ACHIEVEMENTS
}

func save():
	print("Saving...")
	var save_dict = {
		"achievements": Achievements.current,
	}
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_dict))

func load_game():
	print("Loading...")
	if not FileAccess.file_exists("user://savegame.save"):
		print("Save data not found.")
		return # Error! We don't have a save to load.

	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var save_dict = JSON.parse_string(save_file.get_as_text())
	var current = save_dict["achievements"]
	for k in current: # Change keys into integers instead of strings
		Achievements.current[int(k)] = current[k]

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_Y:
					#print("Granting Achievement")
					#Achievements.current = {}
					#Achievements.raise_progress(Achievements.Achievements.STRONGMAN)
					save()
					#load_game()

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

func show_achievements():
	achievements._load_achievements()
	achievements.show()

func _clear_scene():
	for child in $LoadedScene.get_children():
		print("SCENE CLEARED")
		child.queue_free()

func _load_scene(scene:Scenes, level_data:Level.LevelData=null):
	var new_scene
	get_tree().paused = false
	match scene:
		Scenes.MENU:
			Globals.main.music_man.target_song = ""
			new_scene = load("res://scenes/UI/MainMenu2.tscn").instantiate()
		Scenes.LEVEL_SELECT:
			new_scene = load("res://scenes/UI/select2.tscn").instantiate()
		Scenes.LEVEL_FIELD:
			new_scene = load("res://scenes/Levels/field.tscn").instantiate()
		Scenes.LEVEL_TUTORIAL:
			new_scene = load("res://scenes/Levels/tutorial_2.tscn").instantiate()
		Scenes.LEVEL_TUNDRA:
			new_scene = load("res://scenes/Levels/snow_map.tscn").instantiate()
		Scenes.LEVEL_DESERT:
			new_scene = load("res://scenes/Levels/desert_map.tscn").instantiate()
		Scenes.PAUSE:
			new_scene = load("res://scenes/UI/PauseMenu.tscn").instantiate()
		Scenes.ACHIEVEMENTS:
			new_scene = load("res://scenes/UI/unlock_screen.tscn").instantiate()
		_:
			print("ERROR: SCENE NOT FOUND")
			return
	Globals.current_level = scene
	if new_scene is Level:
		new_scene.level_data = level_data
		Globals.current_leveldata = level_data
		Globals.level = new_scene
		$AnimationPlayer.play("fade_in")

		## Must use lambda or else an unwated parameter is passed
		$AnimationPlayer.animation_finished.connect(
			func(_x): 
				_clear_scene()
				$LoadedScene.add_child(new_scene)
				$AnimationPlayer.animation_finished.disconnect($AnimationPlayer.animation_finished.get_connections()[0].callable)
		)

		new_scene.ready.connect($AnimationPlayer.play.bind("fade_out"))
	else:
		_clear_scene()
		$LoadedScene.add_child(new_scene)

func _display_achievement(achievement:Achievements.Achievements):
	$CanvasLayer/AspectRatioContainer/PanelContainer2.load_achievement(achievement)
	$CanvasLayer/AspectRatioContainer/AnimationPlayer.play("popup")

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
	Achievements.achievement_gained.connect(_display_achievement)
	tree_exiting.connect(save) # Save on exit
	#child_entered_tree.connect(func(): print("NEW ONE 11"))
	load_game()

func _pause():
	_load_scene(Scenes.PAUSE)
	print(get_tree().current_scene)
