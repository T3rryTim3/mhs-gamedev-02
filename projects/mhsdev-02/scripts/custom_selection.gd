extends Control

@onready var tree:Tree = $Tree

var maps:TreeItem
var root:TreeItem

var options = {
	"maps": {
		"Field": Main.Scenes.LEVEL_FIELD,
		"Tundra": Main.Scenes.LEVEL_TUNDRA
	},
	"settings": [
		["Name", [0,10], 0.5]
	]
}

func _ready() -> void:
	root = tree.create_item()
	maps = tree.create_item(root)
	
	for k in options["maps"]:
		var option = tree.create_item(maps)
		option.set_text(0, k)
		option.set_metadata(0, options["maps"][k])
		
