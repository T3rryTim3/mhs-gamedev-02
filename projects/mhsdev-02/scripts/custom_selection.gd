extends Control

@onready var tree:Tree = $Tree

var maps:TreeItem
var root:TreeItem
var sets:TreeItem

var options = {
	"maps": {
		"Field": Main.Scenes.LEVEL_FIELD,
		"Tundra": Main.Scenes.LEVEL_TUNDRA,
		"Desert": Main.Scenes.LEVEL_DESERT
	},
	"settings": [
		["Name", [1,10], 0.5]
	]
}

func _ready() -> void:
	root = tree.create_item()
	maps = tree.create_item(root)
	sets = tree.create_item(root)
	
	
	maps.set_text(0,"Maps")
	root.set_text(0,"Curse")
	sets.set_text(0, "Settings")
	
	for k in options["maps"]:
		var option = tree.create_item(maps)
		option.set_text(0, k)
		option.set_metadata(0, options["maps"][k])
	
	
	for i in options["settings"]:
		var option = tree.create_item(sets)
		#option.set_text(0, "test")
		option.set_cell_mode(1,TreeItem.CELL_MODE_RANGE)
		option.set_editable(1, true)
		#option.
		
