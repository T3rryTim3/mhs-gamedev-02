extends Control

var levels = [
	{
		"name": "Field",
		"scene_enum": Main.Scenes.LEVEL_FIELD,
		"image_path": "res://images/placeholder/image.png"
	},
	
	{
		"name": "Tutorial",
		"scene_enum": Main.Scenes.LEVEL_TUTORIAL,
		"image_path": "res://images/items/bread.png"
	}
]

var current_level_index = 0

func update_button(button):
	var data = levels[current_level_index]
	var tex = load(data["image_path"])
	if tex:
		button.texture_normal = tex
	button.set("level_data", data)

func _ready():
	var levelbutton = $TextureButton
	
	var forward = $Button
	var back = $Button2
	
	update_button(levelbutton)
	

func _on_Forward_pressed():
	current_level_index += 1
	if current_level_index >= levels.size():
		current_level_index = 0 
	update_button($TextureButton)

func _on_Back_pressed():
	current_level_index -= 1
	if current_level_index < 0:
		current_level_index = levels.size() - 1
	update_button($TextureButton)
		

func _on_LevelButton_pressed():
	Globals.main._load_scene(levels[current_level_index]["scene_enum"])
	

func _on_back_pressed() -> void:
	Globals.main._load_scene(Main.Scenes.MENU)
