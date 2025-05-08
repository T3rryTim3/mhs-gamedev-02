extends Control

@onready var bgc = $"Background Colour"
@onready var bgg = $"Background Gradient"
@onready var tree = $HSplitContainer/Tree

@onready var title_label = $HSplitContainer/PanelContainer2/MarginContainer/VBoxContainer/Title
@onready var desc_label = $HSplitContainer/PanelContainer2/MarginContainer/VBoxContainer/LevelDesk
@onready var image_border = $HSplitContainer/PanelContainer2/MarginContainer/MarginContainer/TextureRect/MarginContainer/ColorRect

var levels:Array
var root:TreeItem

var current_level:Dictionary
var current_mode:Dictionary



var all_levels = [
	{
		"name": "Tutorial",
		"description": "Learn the basics.",
		"color": Color(0.9,0.9,0.9),
		"text_color": Color(0,0,0),
		"bg_color":Color(1,1,1),
		"scene_enum": Main.Scenes.LEVEL_TUTORIAL,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Tutorial",
				"leveldata": Config.GameDifficulties.TUTORIAL,
				"bg_color": Color(0,0,0),
				"desc": [
					["None", Color(0.4,1,0.4)]
				]
			}
		]
	},
	{
		"name": "Field",
		"description": "An empty field perfect for farming.",
		"color": Color(0,1,0),
		"text_color": Color("004516"),
		"bg_color":Color(0.108,0.5,0),
		"scene_enum": Main.Scenes.LEVEL_FIELD,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.FIELD_STANDARD,
				#"color" : Color(0.4, 1, 0.4),
				"bg_color":Color(0.799,0.948,0.716),
				"desc": [
					["55s Event delay", Color(1,0,0)],
					["-0.4 Temperature", Color(1,0,0)]
				]
				
			},
			{
				"name": "Rowdy",
				"achievement": Achievements.Achievements.FIELD_STANDARD,
				"leveldata": Config.GameDifficulties.FIELD_ROWDY,
				#"color" : Color(1, 1, 0.4),
				"bg_color": Color("f1ea6d"),
				"desc": [
					["-10s between events", Color(1,0,0)],
					["Hunger decreases faster", Color(1,0,0)],
					["Thirst decreases faster", Color(1,0,0)],
					["Events are stronger", Color(1,0,0)]
				]
			},
			{
				"name": "Mayhem",
				"achievement": Achievements.Achievements.FIELD_ROWDY,
				#"color" : Color(1, 0.4, 0.4),
				"bg_color": Color("ec4e00"),
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
		"color": Color(1,1,1),
		"text_color": Color("310095"),
		"bg_color": Color("f1f3ff"),
		"scene_enum": Main.Scenes.LEVEL_TUNDRA,
		"achievement": Achievements.Achievements.FIELD_STANDARD,
		"image_path": "res://images/placeholder/Screenshot from 2025-05-01 20-43-53.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.TUNDRA_STANDARD,
				#"color" : Color("00f0fc"),
				"bg_color":Color("00f0fc"),
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
				#"color" : Color("ea00c0"),
				"bg_color": Color("ea00c0"),
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
				#"color" : Color("fa0008"),
				"bg_color": Color("ec4e00"),
				"desc": [
					["All events are doubled", Color(1,0,0)],
					["Temperature drains twice as fast", Color(1,0,0)]
				]
			}
		]
	},
	{
		"name": "Desert",
		"description": "A harsh environment requiring a good source of water.",
		"color": Color(1,0.9,0),
		"bg_color": Color("fcfa6f"),
		"text_color": Color("483000"),
		"scene_enum": Main.Scenes.LEVEL_TUNDRA,
		"achievement": Achievements.Achievements.FIELD_STANDARD,
		"image_path": "res://images/placeholder/Screenshot from 2025-05-01 20-43-53.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.TUNDRA_STANDARD,
				"bg_color": Color("fa8900"),
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
				"bg_color": Color("a66cf6"),
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
				"bg_color": Color("ff384d"),
				"desc": [
					["All events are doubled", Color(1,0,0)],
					["Temperature drains twice as fast", Color(1,0,0)]
				]
			}
		]
	},
	{
		"name": "Custom",
		"description": "A sandbox to play as you wish",
		"color": Color(1,0,1),
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

func _ready():
	root = tree.create_item()
	tree.hide_root = true

	levels = []
	for level in all_levels:
		#if "achievement" in level:
			#if not Achievements.has_achievement(level["achievement"]):
				#continue
		levels.append(level)

	print(levels)

	var level_index = 0
	
	# Load levels
	for level in levels:

		levels[level_index]["type"] = "level"

		var level_item = tree.create_item()
		level_item.set_text(0, level["name"])
		level_item.set_metadata(0, level)
		if "color" in level:
			level_item.set_custom_color(0, level["color"])

		# Load modes
		var mode_index = 0
		for mode in level["modes"]:

			level["modes"][mode_index]["type"] = "mode"

			#if "achievement" in mode:
				#if not Achievements.has_achievement(mode["achievement"]):
					#continue

			var mode_item = tree.create_item(level_item)
			mode_item.set_text(0, mode["name"])
			mode_item.set_metadata(0, mode)
			
			if "color" in mode:
				mode_item.set_custom_color(0, mode["color"])
			elif "color" in level:
				mode_item.set_custom_color(0, level["color"])

			mode_index += 1

		level_index += 1
			
	tree.item_selected.connect(_item_selected)
	tree.item_activated.connect(_item_activated)
	
func _item_selected():
	# Store the data in a variable
	var data = tree.get_selected().get_metadata(0)
	var level_data = tree.get_selected().get_parent().get_metadata(0)

	# Verify that the selected item is a mode
	if data["type"] != "mode":
		return

	if level_data:
		current_level = level_data
	if data:
		current_mode = data

	# Load the data regarding the title, description, etc.
	level_data["name"] 
	
	# Load the colors
	_update_color(data, level_data)

func _item_activated():
	print("ACTIVATED")
	print(current_level)
	if not current_level:
		print("Return")
		return
	var level_data
	if current_level["name"] == "Custom":
		return #TODO: Load slider values into a leveldata object
	else:
		level_data = Config.get_difficulty_level_data(current_mode["leveldata"])
	Globals.current_level = current_level["scene_enum"]
	Globals.main._load_scene(current_level["scene_enum"], level_data)

func _update_color(mode:Dictionary, level:Dictionary) -> void:
	var level_color
	var mode_color
	var text_color

	if "bg_color" in level:
		level_color = level["bg_color"]
	else:
		level_color = Color.ALICE_BLUE

	if "bg_color" in mode:
		mode_color = mode["bg_color"]
	else:
		mode_color = Color.WHITE

	if "text_color" in level:
		text_color = level["text_color"]
	else:
		text_color = Color.WHITE

	bgc.target_color = level_color
	bgg.target_color = mode_color
	title_label.target_color = text_color
	desc_label.target_color = text_color
	image_border.target_color = text_color

	if "name" in level:
		title_label.text = level["name"]
	if "description" in level:
		desc_label.text = level["description"]
	
