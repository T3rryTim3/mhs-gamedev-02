extends PanelContainer

@onready var mapselection = $VBoxContainer/OptionButton

var maps = [
	{
		"name": "Field",
		"scene_enum": Main.Scenes.LEVEL_FIELD
	},
		{
		"name": "Tundra",
		"scene_enum": Main.Scenes.LEVEL_TUNDRA
	},
		{
		"name": "Desert",
		"scene_enum": Main.Scenes.LEVEL_DESERT
	}
]


func _ready():
	visible = false
	_update_values()
	mapselection.clear()
	for map_data in maps:
		var label = map_data["name"]
		mapselection.add_item(label)
		var index = mapselection.get_item_count() - 1
		mapselection.set_item_metadata(index, map_data)
	mapselection.connect("item_selected", Callable(self, "_on_mapselection_item_selected"))

	
	

func _update_values():
	var data = Level.LevelData.new()
	data.event_cooldown = $VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer/HSplitContainer/VBoxContainer2/Cooldown.value
	data.item_spawn_cooldown = $VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer2/HSplitContainer/VBoxContainer2/ItemSpawn.value
	data.temp_drain = $VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer3/HSplitContainer/VBoxContainer2/Temperature.value
	data.strength_per_minute = $VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer4/HSplitContainer/VBoxContainer2/Events.value
	data.thirst_multi = $VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer5/HSplitContainer/VBoxContainer2/Thirst.value
	data.hunger_multi = $VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer6/HSplitContainer/VBoxContainer2/Hunger.value
	data.event_multiplier = $VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer8/HSplitContainer/VBoxContainer2/EMultiplier.value
	
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer/HSplitContainer/VBoxContainer2/Cooldown/Label.text = str(data.event_cooldown)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer2/HSplitContainer/VBoxContainer2/ItemSpawn/Label.text = str(data.item_spawn_cooldown)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer3/HSplitContainer/VBoxContainer2/Temperature/Label.text = str(data.temp_drain)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer4/HSplitContainer/VBoxContainer2/Events/Label.text = str(data.strength_per_minute)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer5/HSplitContainer/VBoxContainer2/Thirst/Label.text = str(data.thirst_multi)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer6/HSplitContainer/VBoxContainer2/Hunger/Label.text = str(data.hunger_multi)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer8/HSplitContainer/VBoxContainer2/EMultiplier/Label.text = str(data.event_multiplier)

func _sliders():
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer/HSplitContainer/VBoxContainer2/Cooldown.drag_ended.connect(_update_values)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer2/HSplitContainer/VBoxContainer2/ItemSpawn.drag_ended.connect(_update_values)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer3/HSplitContainer/VBoxContainer2/Temperature.drag_ended.connect(_update_values)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer4/HSplitContainer/VBoxContainer2/Events.drag_ended.connect(_update_values)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer5/HSplitContainer/VBoxContainer2/Thirst.drag_ended.connect(_update_values)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer6/HSplitContainer/VBoxContainer2/Hunger.drag_ended.connect(_update_values)
	$VBoxContainer/MarginContainer7/VBoxContainer/MarginContainer8/HSplitContainer/VBoxContainer2/EMultiplier.drag_ended.connect(_update_values)



func _on_button_pressed():
	visible = false
	


func _on_start_pressed() -> void:
	var selected_index = mapselection.get_selected()
	
	if selected_index <= 0:
		print("Please select a valid map.")
		return
	var selected_data = mapselection.get_item_metadata(selected_index)
	
	if selected_data:
		var scene_path = selected_data["scene_enum"]
		get_tree().change_scene(scene_path)
	else:
		print("No scene path found for the selected item.")
