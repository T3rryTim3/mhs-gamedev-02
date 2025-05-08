extends Control

@onready var bgc = $"Background Colour"
@onready var bgg = $"Background Gradient"
@onready var tree = $HSplitContainer/Tree

var levels:Array
var root:TreeItem



var all_levels = [
	{
		"name": "Tutorial",
		"description": "A guide on how to use (parentheses)",
		"color": Color(0.9,0.9,0.9),
		"bg_color":Color(0.922,0.962,0.387),
		"scene_enum": Main.Scenes.LEVEL_TUTORIAL,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Tutorial",
				"leveldata": Config.GameDifficulties.TUTORIAL,
				"color": Color(0.9,0.9,0.9),
				"bg_color":Color(0.271,0.0,0.111),
				"desc": [
					["None", Color(0.4,1,0.4)]
				]
			}
		]
	},
	{
		"name": "Field",
		"description": "An empty field perfect for not having (parentheses)",
		"color": Color(0,1,0),
		"bg_color":Color(0,0.504,0.083),
		"scene_enum": Main.Scenes.LEVEL_FIELD,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.FIELD_STANDARD,
				"color" : Color(0.4, 1, 0.4),
				"bg_color":Color(0.252,0.559,0.0),
				"desc": [
					["55s Event delay", Color(1,0,0)],
					["-0.4 Temperature", Color(1,0,0)]
				]
				
			},
			{
				"name": "Rowdy",
				"achievement": Achievements.Achievements.FIELD_STANDARD,
				"leveldata": Config.GameDifficulties.FIELD_ROWDY,
				"color" : Color(1, 1, 0.4),
				"bg_color":Color(0.873, 0.896, 0.0),
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
				"color" : Color(1, 0.4, 0.4),
				"bg_color":Color(0.878, 0.0, 0.282),
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
		"bg_color":Color(0.0, 0.573, 0.655),
		"scene_enum": Main.Scenes.LEVEL_TUNDRA,
		"achievement": Achievements.Achievements.FIELD_STANDARD,
		"image_path": "res://images/placeholder/Screenshot from 2025-05-01 20-43-53.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.TUNDRA_STANDARD,
				"color": Color(1,1,1),
				"bg_color":Color(0.52, 1.0, 0.914),
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
				"color": Color(1,1,1),
				"bg_color":Color(0.697, 0.001, 0.775),
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
				"color": Color(1,1,1),
				"bg_color":Color(0.756, 0.0, 0.433),
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
		"bg_color":Color(0.821, 0.73, 0.0),
		"scene_enum": Main.Scenes.LEVEL_TUNDRA,
		"achievement": Achievements.Achievements.FIELD_STANDARD,
		"image_path": "res://images/placeholder/Screenshot from 2025-05-01 20-43-53.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.TUNDRA_STANDARD,
				"color": Color(1,0.9,0),
				"bg_color":Color(0.074, 0.815, 1.0),
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
				"color": Color(1,0.9,0),
				"bg_color":Color(0.367, 0.175, 0.0),
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
				"color": Color(1,0.9,0),
				"bg_color":Color(0.986, 0.0, 0.558),
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
		"bg_color":Color(0.306, 0.001, 0.455),
		"scene_enum": "p",
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Custom",
				"leveldata": Config.GameDifficulties.TUTORIAL,
				"color": Color(1,0,1),
				"bg_color":Color(0.986, 0.0, 0.558),
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

			mode_index += 1

		level_index += 1
			
	tree.item_selected.connect(_item_selected)
	
func _item_selected():
	print(tree.get_selected())
	print(tree.get_selected().get_metadata(0))
	# Store the data in a variable
	var data = tree.get_selected().get_metadata(0)
	var level_data = tree.get_selected().get_parent().get_metadata(0)
	# Verify that the selected item is a mode
	if data["type"] != "mode":
		return
	# Load the data regarding the title, description, etc.
	level_data["name"] 
	
	# Load the colors
	_update_color(data, level_data)

func _update_color(mode:Dictionary, level:Dictionary) -> void:
	var level_color
	var mode_color
	if "bg_color" in level:
		level_color = level["bg_color"]
	else:
		level_color = Color.ALICE_BLUE
	if "bg_color" in mode:
		mode_color = mode["bg_color"]
	else:
		mode_color = Color.WHITE
	bgc.target_color = level_color
	bgg.target_color = mode_color
