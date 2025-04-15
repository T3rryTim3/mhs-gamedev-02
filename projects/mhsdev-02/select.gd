extends Control

var levels = [
	{
		"name": "Field",
		"node_path": "res://scenes/Levels/field.tscn",
		"image_path": "res://images/items/wheat.png"
	},
	
	{
		"name": "Tutorial",
		"node_path": "res://scenes/Levels/tutorial.tscn",
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
		

func _on_LevelButton_pressed(level_data):
	visible = false
	
