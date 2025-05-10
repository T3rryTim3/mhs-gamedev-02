extends Control
class_name SelectMenu

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

var image_move_prog:float


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
				"text_color": Color("ffffff"),
				"image": "res://images/UI/Thumbnail/tutorial.png",
				"desc": [
					["None", Color(0.4,1,0.4)]
				]
			}
		]
	},
	{
		"name": "Field",
		"description": "An empty field perfect for farming.",
		"music_path": "res://Audio/Music/Field.mp3",
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
				"text_color": Color("a8f6b1"),
				"image": "res://images/UI/Thumbnail/field_standard.png",
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
				"text_color": Color("8df799"),
				"image": "res://images/UI/Thumbnail/field_rowdy.png",
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
				"leveldata": Config.GameDifficulties.FIELD_MAYHEM,
				#"color" : Color(1, 0.4, 0.4),
				"bg_color": Color("ec4e00"),
				"text_color": Color("7cf78a"),
				"image": "res://images/UI/Thumbnail/field_mayhem.png",
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
		"music_path": "res://Audio/Music/frost-final.mp3",
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
				"image": "res://images/UI/Thumbnail/tundra_standard.png",
				"text_color": Color("c7e0ff"),
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
				"text_color": Color("a7cfff"),
				"image": "res://images/UI/Thumbnail/tundra_rowdy.png",
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
				"bg_color": Color("73b2ff"),
				"text_color": Color("a7cfff"),
				"image": "res://images/UI/Thumbnail/tundra_mayhem.png",
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
		"music_path": "res://Audio/Music/Desert-final.wav",
		"color": Color(1,0.9,0),
		"bg_color": Color("fcfa6f"),
		"text_color": Color("483000"),
		"scene_enum": Main.Scenes.LEVEL_DESERT,
		"achievement": Achievements.Achievements.TUNDRA_STANDARD,
		"image_path": "res://images/placeholder/Screenshot from 2025-05-01 20-43-53.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.TUNDRA_STANDARD,
				"bg_color": Color("fa8900"),
				"image": "res://images/UI/Thumbnail/desert_standard.png",
				"text_color": Color("ede4b9"),
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
				"image": "res://images/UI/Thumbnail/desert_rowdy.png",
				"text_color": Color("ede1a8"),
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
				"image": "res://images/UI/Thumbnail/desert_mayhem.png",
				"text_color": Color("eddb80"),
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
				"name": "Custom",
				"leveldata": Config.GameDifficulties.TUTORIAL,
				"image": "res://images/UI/Thumbnail/custom.png",
				"desc": [
					["x2 Events", Color(1,0,0)],
					["x2 Events", Color(1,0,0)]
				]
			}
		]
		
	}
]

func _invert_hex(hex:String) -> String: ## Inverts the passed hex color
	var chars = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']
	var new = ""
	for char in hex.split(""):
		var char_pos = chars.find(char)
		new = new + str(chars[(len(chars)-1) - char_pos])
	return new


func _ready():
	root = tree.create_item()
	tree.hide_root = true

	levels = []
	for level in all_levels:
		#if "achievement" in level:
			#if not Achievements.has_achievement(level["achievement"]):
				#continue
		levels.append(level)

	var level_index = 0
	var selected_level

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
		var mode_item
		for mode in level["modes"]:

			level["modes"][mode_index]["type"] = "mode"

			#if "achievement" in mode:
				#if not Achievements.has_achievement(mode["achievement"]):
					#continue

			mode_item = tree.create_item(level_item)
			mode_item.set_text(0, mode["name"])
			mode_item.set_metadata(0, mode)

			if mode["name"] == "Tutorial":
				selected_level = mode_item

			if "color" in mode:
				mode_item.set_custom_color(0, mode["color"])
			elif "color" in level:
				mode_item.set_custom_color(0, level["color"])

			mode_index += 1

		level_index += 1
			
	tree.item_selected.connect(_item_selected)
	tree.item_activated.connect(_item_activated)

	tree.set_selected(selected_level, 0)

	_update_color(levels[0], levels[0]["modes"][0])
	
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
	if not current_level:
		return
	var level_data
	if current_level["name"] == "Custom":
		$CustomSliders.visible = true
	else:
		level_data = Config.get_difficulty_level_data(current_mode["leveldata"])
	Globals.current_level = current_level["scene_enum"]
	if "music_path" in current_level:
		Globals.main.music_man.target_song = current_level["music_path"]
	Globals.main._load_scene(current_level["scene_enum"], level_data)

func _update_color(mode:Dictionary, level:Dictionary) -> void:
	var level_color
	var mode_color
	var text_color:Color
	var text_outline

	if "bg_color" in level:
		level_color = level["bg_color"]
	else:
		level_color = Color.ALICE_BLUE

	if "bg_color" in mode:
		mode_color = mode["bg_color"]
	else:
		mode_color = Color.WHITE

	if "text_color" in mode:
		text_color = mode["text_color"]
	elif "text_color" in level:
		text_color = level["text_color"]
	else:
		text_color = Color.WHITE
	#text_outline = _invert_hex(text_color.to_html(false))
	text_outline = text_color
	text_outline.s = -text_outline.s + 1
	text_outline.v = -text_outline.v + 1

	bgc.target_color = level_color
	bgg.target_color = mode_color
	title_label.target_color = text_color
	desc_label.target_color = text_color
	title_label.target_outline = text_outline
	desc_label.target_outline = text_outline
	image_border.target_color = text_color

	if "name" in level:
		title_label.text = level["name"]
	if "description" in level:
		desc_label.text = level["description"]
	if "image" in mode:
		$TextureRect.texture = load(mode["image"])

func _process(delta: float) -> void:
	image_move_prog += delta / 8
	var amplitude = ($TextureRect.get_rect().size.y * $TextureRect.scale.y - get_viewport_rect().size.y)
	$TextureRect.position.y = amplitude * -pow(sin(image_move_prog),2)
