extends Control

@onready var tree:Tree = $Tree
@onready var sliders = $Tree/CustomSliders

var maps:TreeItem
var root:TreeItem
var sets:TreeItem


var options = {
	"maps": {
		"Field": Main.Scenes.LEVEL_FIELD,
		"Tundra": Main.Scenes.LEVEL_TUNDRA,
		"Desert": Main.Scenes.LEVEL_DESERT
	},
	"settings": {
	}
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
		
	
	tree.item_activated.connect(_item_activated)
	


func _item_activated():
	var selected_item = tree.get_selected()
	if selected_item == sets:
		sliders.visible = true
	else:
		sliders.visible = false 
