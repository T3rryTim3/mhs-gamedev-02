extends Control

var levels = [
	{
		"name": "Field",
		"node_path": "res://scenes/Levels/field.tscn"
	},
	#{
		#"name": "Tutorial",
		#"node_path": "tutorial"
	#}
]


func _ready():
	var buttons = [
		$TextureButton,
		$TextureButton2
	]
	
	for i in range(levels.size()):
		var data = levels[i]
		var button = buttons[i]
		
		var tex = load(data["node_path"])
		if tex:
			button.texture_normal = tex
		
		button.set("level_data", data)
		
		button.pressed.connect(_on_LevelButton_pressed.bind(data))

func _on_LevelButton_pressed(level_data):
	visible = false
	

func _on_button_pressed() -> void:
	pass 
	

func _on_button_2_pressed() -> void:
	pass
