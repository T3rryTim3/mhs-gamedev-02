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

func _update_stat_bars():
	$Hunger.value = player.state.hunger.val * 100 / player.state.hunger.val_max
	$Thirst.value = player.state.thirst.val * 100 / player.state.thirst.val_max
	$Health.value = player.health * 100 / player.max_health

func _process(delta: float) -> void:
	if not player:
		return
	_update_stat_bars()

	if Globals.level is Level:
		Gamestats.level_time += delta
	var minutes = Gamestats.level_time / 60
	var seconds = fmod(Gamestats.level_time, 60)
	var milliseconds = fmod(Gamestats.level_time, 1) * 100
	var time_string = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	$Timer.text = time_string
	#$VBoxContainer/temp.value = player.state.temp.val * 100 / player.state.temp.val_max
	
