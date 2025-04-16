extends Control

var player:Player

@onready var RemoveDisplay = $RemovingDisplay
@onready var BuildDisplay = $BuildingDisplay

func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

func _update_mode_display(): # Updates the 'Bulding' and 'Removing' displays as needed
	if player.delete_mode:
		RemoveDisplay.show()
		BuildDisplay.hide()
	elif player.current_blueprint:
		BuildDisplay.show()
		RemoveDisplay.hide()
	else:
		BuildDisplay.hide()
		RemoveDisplay.hide()

func _ready():
	await _get_level().ready
	player = _get_level().player
	player.give_upgrade.connect($UpgradeMenu.display_menu)
	player.mode_changed.connect(_update_mode_display)

	_update_mode_display()

func _process(_delta: float) -> void:
	if not player:
		return
	$VBoxContainer/hunger.value = player.state.hunger.val * 100 / player.state.hunger.val_max
	$VBoxContainer/thirst.value = player.state.thirst.val * 100 / player.state.thirst.val_max
	$VBoxContainer/temp.value = player.state.temp.val * 100 / player.state.temp.val_max
