extends Control

var tips = [
	"You can add water to wheat fields to heal them.",
	"Some items slowly destroy over time.",
	"Barricades can be used to stop events from breaking your buildings.",
	"Powering the machine early helps you survive longer.",
	"You can carry multiple items at once and rotate them around (Default R). ",
	"Press Q (Default) to drop items without picking anything up.",
	"Sprinting increases your thirst drain, so use it wisely.",
	"Sprinting increases your thirst drain, so use it wisely."
]

func select_tip():
	
	var _index = randi() % tips.size() 
	var value = tips[_index] 
	print (value)
	$PanelContainer/Label.text = str(value)

func _ready() -> void:
	select_tip()
