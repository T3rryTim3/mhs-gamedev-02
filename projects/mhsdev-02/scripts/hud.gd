extends Control

var player:Player

func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

func _ready():
	await _get_level().ready
	player = _get_level().player

func _process(_delta: float) -> void:
	if not player:
		return
	$VBoxContainer/hunger.value = player.state.hunger.val
	$VBoxContainer/thirst.value = player.state.thirst.val
	$VBoxContainer/temp.value = player.state.temp.val
