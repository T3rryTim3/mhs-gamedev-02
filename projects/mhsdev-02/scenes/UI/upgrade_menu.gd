extends Control

@onready var upgrade_item = preload("res://scenes/UI/upgrade_item.tscn")
@onready var upgrade_list = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer

func display_menu():
	# Remove past items
	for child in upgrade_list.get_children():
		if not (child is Panel):
			continue
		child.queue_free()

	# Select the next upgrades
	var upgrades:Array
	var remaining = Upgrades.get_upgrades()

	while len(remaining) > 0: # Ensure there are enough upgrades
		upgrades.append(remaining.pick_random())
		if len(upgrades) >= Config.UPGRADE_COUNT:
			break

	# Add the buttons to select the upgrades
	for upgrade in upgrades:
		print("Add")
		var data = Upgrades.get_upgrade_data(upgrade)
		var new_item = upgrade_item.instantiate()
		new_item.data = data
	
	show()
