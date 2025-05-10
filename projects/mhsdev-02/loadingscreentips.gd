extends Control

var tip_cooldown:float = 6
var current_tip_cooldown:float = 0

var tips = [
	"You can add water to wheat fields to heal them.",
	"Some items slowly destroy over time.",
	"Barricades can be used to stop events from breaking your buildings.",
	"Powering the machine early helps you survive longer.",
	"You can carry multiple items at once and rotate them around (Default R). ",
	"Press Q (Default) to drop items without picking anything up.",
	"Sprinting increases your thirst drain, so use it wisely.",
	"Hit stations with your pitchfork to speed them up.",
	"You can deflect fireballs by hitting them.",
	"Balance is important; stay alive while also fueling the machine.",
	"Power the machine enough to win the game."
]

func select_tip():
	
	var _index = randi() % tips.size() 
	var value = tips[_index] 
	$PanelContainer/Label.text = str(value)

func _process(delta: float) -> void:
	current_tip_cooldown += delta
	if current_tip_cooldown >= tip_cooldown:
		select_tip()
		current_tip_cooldown = 0

func _ready() -> void:
	select_tip()
