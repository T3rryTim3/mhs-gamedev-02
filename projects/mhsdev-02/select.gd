extends Control

var levels = [
	{
		"name": "Field",
		"description": "An empty field perfect for not having (parentheses)",
		"scene_enum": Main.Scenes.LEVEL_FIELD,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.FIELD_STANDARD,
				"desc": [
					["55s Event delay", Color(1,0,0)],
					["-0.4 Temperature", Color(1,0,0)]
				]
				
			},
			{
				"name": "Rowdy",
				"leveldata": Config.GameDifficulties.FIELD_ROWDY,
				"desc": [
					["-10s between events", Color(1,0,0)],
					["Hunger decreases faster", Color(1,0,0)],
					["Thirst decreases faster", Color(1,0,0)],
					["Events are stronger", Color(1,0,0)]
				]
			},
			{
				"name": "Mayhem",
				"leveldata": Config.GameDifficulties.FIELD_MAYHEM,
				"desc": [
					["All events are doubled", Color(1,0,0)],
					["Temperature drains twice as fast", Color(1,0,0)]
				]
			}
		]
	},
	{
		"name": "Tundra",
		"description": "A harsh environment requiring a good source of heat and food.",
		"scene_enum": Main.Scenes.LEVEL_FIELD,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.TUNDRA_STANDARD,
				"desc": [
					["60s Event delay", Color(1,0,0)],
					["-1.2 Temperature", Color(1,0,0)],
					["Hunger drains slower", Color(0,1,0)],
					["Thirst drains slower", Color(0,1,0)]
				]
				
			},
			{
				"name": "Rowdy",
				"leveldata": Config.GameDifficulties.TUNDRA_ROWDY,
				"desc": [
					["-10s between events", Color(1,0,0)],
					["Hunger decreases faster", Color(1,0,0)],
					["Thirst decreases faster", Color(1,0,0)],
					["Events are stronger", Color(1,0,0)]
				]
			},
			{
				"name": "Mayhem",
				"leveldata": Config.GameDifficulties.TUNDRA_MAYHEM,
				"desc": [
					["All events are doubled", Color(1,0,0)],
					["Temperature drains twice as fast", Color(1,0,0)]
				]
			}
		]
	},
	{
		"name": "Tutorial",
		"description": "A guide on how to use (parentheses)",
		"scene_enum": Main.Scenes.LEVEL_TUTORIAL,
		"image_path": "res://images/placeholder/image.png",
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
	},
	{
		"name": "Custom",
		"description": "A sandbox to play as you wish",
		"scene_enum": "p",
		"image_path": "res://images/placeholder/image.png",
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
@onready var mode_dropdown = $HSplitContainer/PanelContainer/MarginContainer/VBoxContainer/Difficulty
@onready var descriptions = $HSplitContainer/PanelContainer/MarginContainer/VBoxContainer/Descriptions
@onready var custom_sliders = $HSplitContainer/PanelContainer/MarginContainer/VBoxContainer/CustomSliders


#func update_button(button):
	#var data = levels[current_level_index]
	#var tex = load(data["image_path"])
	#if tex:
		#button.texture_normal = tex
	#button.set("level_data", data)

func _ready():
	#var levelbutton = $TextureButton
	custom_sliders.visible = false
	_update_data()

	#update_button(levelbutton)

func _update_data(): ## Updates based on the current scene selected
	var level = levels[current_level_index]
	mode_dropdown.selected = 0
	print(current_level_index)
	_update_desc()
	mode_dropdown.clear()
	for mode_index in len(level["modes"]):
		mode_dropdown.add_item(level["modes"][mode_index]["name"], mode_index)
	$HSplitContainer/PanelContainer2/MarginContainer/VBoxContainer/Title.text = levels[current_level_index]["name"]
	$HSplitContainer/PanelContainer2/MarginContainer/VBoxContainer/LevelDesk.text = levels[current_level_index]["description"]
	$HSplitContainer/PanelContainer2/MarginContainer/VBoxContainer/MarginContainer/TextureRect.texture = load(levels[current_level_index]["image_path"])

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
	print(levels[current_level_index]["scene_enum"])
	var level_data:Level.LevelData
	if levels[current_level_index]["name"] == "Custom":
		return #TODO: Load slider values into a leveldata object
	else:
		level_data = Config.get_difficulty_level_data(levels[current_level_index]["modes"][mode_dropdown.selected]["leveldata"])
	Globals.main._load_scene(levels[current_level_index]["scene_enum"], level_data)
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


func _on_difficulty_item_selected(_index: int) -> void:
	_update_desc()
