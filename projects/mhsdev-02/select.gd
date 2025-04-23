extends Control

var levels = [
	{
		"name": "Field",
		"scene_enum": Main.Scenes.LEVEL_FIELD,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.FIELD_STANDARD,
				"desc": [
					["x2 Events", Color(1,0,0)],
					["x2 Events", Color(1,0,0)]
				]
			},
			{
				"name": "Rowdy",
				"leveldata": Config.GameDifficulties.FIELD_ROWDY,
				"desc": [
					["2x Events", Color(1,0,0)],
					["2x Events", Color(1,0,0)]
				]
			},
			{
				"name": "Mayhem",
				"leveldata": Config.GameDifficulties.FIELD_MAYHEM,
				"desc": [
					["Events", Color(1,0,0)],
					["Events", Color(1,0,0)]
				]
			}
		]
	},
	{
		"name": "Tutorial",
		"scene_enum": Main.Scenes.LEVEL_TUTORIAL,
		"image_path": "res://images/items/bread.png",
		"modes": [
			{
				"name": "Tutorial",
				"leveldata": Config.GameDifficulties.TUTORIAL,
				"desc": [
					["x2 Events", Color(1,0,0)],
					["x2 Events", Color(1,0,0)]
				]
			}
		]
	}
]

var current_level_index = 0
@onready var custom_diff = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
@onready var mode_dropdown = $PanelContainer/MarginContainer/VBoxContainer/Difficulty
@onready var descriptions = $PanelContainer/MarginContainer/VBoxContainer/Descriptions

#func update_button(button):
	#var data = levels[current_level_index]
	#var tex = load(data["image_path"])
	#if tex:
		#button.texture_normal = tex
	#button.set("level_data", data)

func _ready():
	#var levelbutton = $TextureButton
	var forward = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Forward
	var back = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Back
	custom_diff.visible = false
	
	#update_button(levelbutton)

func _update_data(): ## Updates based on the current scene selected
	var level = levels[current_level_index]
	mode_dropdown.selected = 0
	print(current_level_index)
	_update_desc()
	mode_dropdown.clear()
	for mode_index in len(level["modes"]):
		mode_dropdown.add_item(level["modes"][mode_index]["name"], mode_index)

func _on_Forward_pressed():
	current_level_index += 1
	if current_level_index >= levels.size():
		current_level_index = 0 
	_update_data()

func _on_Back_pressed():
	current_level_index -= 1
	if current_level_index < 0:
		current_level_index = levels.size() - 1
	_update_data()

func _on_back_pressed() -> void:
	Globals.main._load_scene(Main.Scenes.MENU)

func _on_start_pressed():
	Globals.main._load_scene(levels[current_level_index]["scene_enum"], levels[current_level_index]["modes"][mode_dropdown.selected]["leveldata"])
	Globals.current_level = levels[current_level_index]["scene_enum"]

func _update_desc():
	var desc = levels[current_level_index]["modes"][mode_dropdown.selected]["desc"]
	for label in descriptions.get_children():
		label.queue_free()
	for line in desc:
		var label:Label = Label.new() 
		label.add_theme_color_override("font_color",line[1])
		label.text = line[0]
		descriptions.add_child(label)

func _on_difficulty_item_selected(index: int) -> void:
	print(current_level_index)
	_update_desc()
