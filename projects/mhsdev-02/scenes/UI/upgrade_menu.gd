extends Control

@onready var upgrade_item = preload("res://scenes/UI/upgrade_item.tscn")
@onready var upgrade_list = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
@onready var desclabel:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/desclabel

func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

func choose_upgrade(upgrade):
	
	var level:Level = _get_level()
	var player:Player = level.player
	
	if not player:
		return
	
	player.add_upgrade(upgrade)
	hide()

func display_menu():
	# Remove past items
	for child in upgrade_list.get_children():
		if child is PanelContainer:
			child.queue_free()

	desclabel.text = ""

	# Select the next upgrades
	var upgrades:Array
	var remaining = Upgrades.get_upgrades()

	while len(remaining) > 0: # Ensure there are enough upgrades
		var choice = remaining.pick_random()
		var data = Upgrades.get_upgrade_data(choice)
		
		# Remove the option if the player has reached the max amount of the chosen upgrade
		if _get_level().player._get_upgrade(choice) >= data["lim"]:
			remaining.erase(choice)

		upgrades.append(choice)
		remaining.erase(choice)
		if len(upgrades) >= Config.UPGRADE_COUNT: # Ensure only 3 upgrades are chosen
			break

	# Add the buttons to select the upgrades
	for upgrade in upgrades:
		var data = Upgrades.get_upgrade_data(upgrade)
		var new_item:PanelContainer = upgrade_item.instantiate()
		new_item.data = data
		upgrade_list.add_child(new_item)
		new_item.button.mouse_entered.connect(func():desclabel.text = data["desc"])
		new_item.button.mouse_exited.connect(func():desclabel.text = "")
		new_item.button.pressed.connect(choose_upgrade.bind(upgrade))
	
	show()
	$AnimationPlayer.play("Popup")
