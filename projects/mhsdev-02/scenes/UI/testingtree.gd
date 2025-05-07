extends Tree

var all_levels = [
	{
		"name": "Tutorial",
		"description": "A guide on how to use (parentheses)",
		"color": Color(0.9,0.9,0.9),
		"scene_enum": Main.Scenes.LEVEL_TUTORIAL,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Tutorial",
				"leveldata": Config.GameDifficulties.TUTORIAL,
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
		"scene_enum": Main.Scenes.LEVEL_FIELD,
		"image_path": "res://images/placeholder/image.png",
		"modes": [
			{
				"name": "Standard",
				"leveldata": Config.GameDifficulties.FIELD_STANDARD,
				"color" : Color(0.4, 1, 0.4),
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
		"scene_enum": Main.Scenes.LEVEL_TUNDRA,
		"achievement": Achievements.Achievements.FIELD_STANDARD,
		"image_path": "res://images/placeholder/Screenshot from 2025-05-01 20-43-53.png",
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

var levels:Array
var root:TreeItem

func _ready():

	root = create_item()
	hide_root = true

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

		var level_item = create_item()
		level_item.set_text(0, level["name"])
		level_item.set_metadata(0, level_index)
		if "color" in level:
			level_item.set_custom_color(0, level["color"])

		# Load modes
		var mode_index = 0
		for mode in level["modes"]:

			#if "achievement" in mode:
				#if not Achievements.has_achievement(mode["achievement"]):
					#continue

			var mode_item = create_item(level_item)
			mode_item.set_text(0, mode["name"])
			mode_item.set_metadata(0, mode_index)
			
			if "color" in mode:
				mode_item.set_custom_color(0, mode["color"])

			mode_index += 1

		level_index += 1
			
	item_selected.connect(_item_selected)
	
func _item_selected():
	print(get_selected())
	print(get_selected().get_metadata(0))
