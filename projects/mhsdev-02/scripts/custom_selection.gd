extends Control

@onready var tree:Tree = $Tree

var maps:TreeItem
var root:TreeItem
var sets:TreeItem

var options = {
	"settings": [
		["Name", [1,10], 0.5]
	]
}

func _ready() -> void:
	root = tree.create_item()
	maps = tree.create_item(root)
	sets = tree.create_item(root)


	maps.set_text(0,"Maps")
	sets.set_text(0, "Settings")
	
	for k in Config.levels:
		if k["scene_enum"] == null:
			return
		if k["scene_enum"] == Globals.main.Scenes.LEVEL_TUTORIAL:
			continue
		if k["name"] == "Custom":
			continue
		var option = tree.create_item(maps)
		option.set_text(0, k["name"])
		option.set_metadata(0, k)

	for i in options["settings"]:
		var option = tree.create_item(sets)
		#option.set_text(0, "test")
		option.set_cell_mode(1,TreeItem.CELL_MODE_RANGE)
		option.set_editable(1, true)
		option.set_range_config(0, i[1][0], i[1][1], i[2])
		#option.
