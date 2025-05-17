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

var exit_button:TreeItem


var all_levels = Config.levels

func _invert_hex(hex:String) -> String: ## Inverts the passed hex color
	var chars = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']
	var new = ""
	for c in hex.split(""):
		var char_pos = chars.find(char)
		new = new + str(chars[(len(chars)-1) - char_pos])
	return new

func _ready():
	Globals.main.music_man.target_song = "res://Audio/Music/Mystic Garden.wav"
	root = tree.create_item()
	tree.hide_root = true

	exit_button = tree.create_item()
	exit_button.set_text(0, "Exit")
	exit_button.set_text_alignment(0, HORIZONTAL_ALIGNMENT_CENTER)
	exit_button.set_metadata(0,"EXITBUTTON")

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

		var level_item:TreeItem = tree.create_item()
		level_item.set_text(0, level["name"])
		level_item.set_metadata(0, level)
		level_item.set_selectable(0, false)
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

	if data is String and data == "EXITBUTTON":
		Globals.main._load_scene(Globals.main.Scenes.MENU)
		return

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
		get_tree().change_scene_to_file("res://custom_sliders.tscn")
	else:
		level_data = Config.get_difficulty_level_data(current_mode["leveldata"])
		if "music_path" in current_level:
			Globals.main.music_man.target_song = current_level["music_path"]
		Globals.main._load_scene(current_level["scene_enum"], level_data)
	Globals.current_level = current_level["scene_enum"]
	
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
