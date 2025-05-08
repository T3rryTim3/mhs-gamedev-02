extends Control

var player:Player

@onready var RemoveDisplay = $RemovingDisplay
@onready var BuildDisplay = $BuildingDisplay
@onready var item_scn = preload("res://scenes/Base/item.tscn")
@onready var item_slot_image = preload("res://images/UI/hand.png")

# If the level is "Tutorial"
var tutorial_mode:bool = false

## Current part of the tutorial the player is on
var tutorial_step:int = 0

func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

func _update_held_items(): ## Updates the held items display
	print("Updated")
	$itemsheld.text = str(len(player.collector.current_resources)) + "/" + str(player.collector.stack_limit)
	
	#if $HeldItems.get_children_count() != player.collector.stack_limit:
		#for child in $HeldItems.get_children():
			#child.queue_free()
		#for x in range(player.collector.stack_limit):
			#var new_rect = TextureRect.new()
			#new_rect.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
			#new_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			#$HeldItems.add_child(new_rect)
#
	#var i:int = 0
	#for child:TextureRect in $HeldItems.get_children():
		#child.texture = load(ItemData.get_item_data(player.collector.current_resources[i])["img_path"])
	

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

func _player_death():
	$Death2.display()

func _ready():
	await _get_level().ready
	player = _get_level().player
	player.give_upgrade.connect($UpgradeMenu.display_menu)
	player.mode_changed.connect(_update_mode_display)
	player.collector.resources_updated.connect(_update_held_items)
	EventMan.event_spawned.connect($DisasterDisplay/AnimationPlayer.play.bind("show"))
	player.death.connect(_player_death)
	$Death2.player = player

	_update_mode_display()
	
	if _get_level().tutorial:
		tutorial_mode = true
		player.blueprint_overlay.stations = [
			StationData.Stations.WATER_PURIFIER
		]
		_next_tutorial_step()

func _update_stat_bars():
	$Hunger.value = player.state.hunger.val * 100 / player.state.hunger.val_max
	$Thirst.value = player.state.thirst.val * 100 / player.state.thirst.val_max
	$Temp.value = player.state.temp.val * 100 / player.state.temp.val_max
	$Health.value = player.health * 100 / player.max_health

func _get_key(action:String) -> String: ## Get the string version of an action's event
	return InputMap.action_get_events(action)[0].as_text().rstrip(" (Physical)")

## Handles all tutorial steps. 'data' is used within the function, and should not be passed.
func _next_tutorial_step(data=null):
	# Yes, I know this code is quite ugly, buuut we needed a tutorial and I didn't feel like making it good.
	# Sincerely, Aidan Wignall
	tutorial_step += 1
	match tutorial_step:
		1: # Pickup wood
			$Timer.text = "Task: Move your cursor over the wood and press " + _get_key("pickup") + " to grab it."
			player.collector.item_collected.connect(_next_tutorial_step)
		2: # Build the well
			# Check validity
			if not (player.collector.current_resources[0].id == ItemData.ItemTypes.WOOD):
				tutorial_step = 1
				return
			player.collector.item_collected.disconnect(_next_tutorial_step)

			$Timer.text = "Task: Drop items as needed into the well blueprint using " + _get_key("drop") + "."

			# Spawn items to build a well
			var cost = StationData.get_station_cost(StationData.Stations.WELL)
			for k in cost:
				for i in range(cost[k]):
					var new_item:Item = item_scn.instantiate()
					new_item.id = k
					new_item.global_position = player.global_position + Vector2(randi_range(-30,30), 20)
					_get_level().items.add_child(new_item)

			# Connect next step
			_get_level().station_built.connect(_next_tutorial_step)
		3: # Open blueprint menu
			# Check validity
			if not (_get_level().get_station_count(StationData.Stations.WELL) > 0):
				tutorial_step = 2
				return

			# Update text and connect next step
			_get_level().station_built.disconnect(_next_tutorial_step)
			$Timer.text = "Task: Press " + _get_key("blueprint") + " to open the blueprint menu."
			player.mode_changed.connect(_next_tutorial_step)
		4: # Build a purifier
			if not (player.current_blueprint):
				tutorial_step = 3
				return
			player.mode_changed.disconnect(_next_tutorial_step)
			_get_level().station_built.connect(_next_tutorial_step)
			$Timer.text = "Task: Select the water purifier, and click somewhere to place it.\n After that, finish builing it by placing the required items inside."
			
			# Spawn items for the purifier
			var cost = StationData.get_station_cost(StationData.Stations.WATER_PURIFIER)
			for k in cost:
				for i in range(cost[k]):
					var new_item:Item = item_scn.instantiate()
					new_item.id = k
					new_item.global_position = player.global_position + Vector2(randi_range(-10,10), 20)
					_get_level().items.add_child(new_item)
		5: # Drink purified water
			if not (_get_level().get_station_count(StationData.Stations.WATER_PURIFIER) > 0):
				tutorial_step = 4
				return
			_get_level().station_built.disconnect(_next_tutorial_step)
			$Timer.text = "Task: Place water from the well into the purifier, \n then drink the purified water by holding " + _get_key("use_item") + "."
			player.item_used.connect(_next_tutorial_step)
		6: # Delete the well
			if not ((data is Item) and data.id == ItemData.ItemTypes.WATER_CLEAN):
				tutorial_step = 5
				return
			player.item_used.disconnect(_next_tutorial_step)
			$Timer.text = "Task: Press " + _get_key("remove_station") + " to enter delete mode and delete the water purifier"
			_get_level().station_deleted.connect(_next_tutorial_step)
		7: # Cook bread
			_get_level().station_deleted.disconnect(_next_tutorial_step)
			_get_level().load_bread_step()
			$Timer.text = "Task: Use the oven to cook and eat bread. Put wheat on the left, and wood on the right.\nYou will need to make a wheat crop to get the wheat."
			player.item_used.connect(_next_tutorial_step)
		8:
			if not ((data is Item) and data.id == ItemData.ItemTypes.BREAD):
				tutorial_step = 7
				return
			player.item_used.disconnect(_next_tutorial_step)
			$Timer.text = "Task: Add the required items into the machine."
			_get_level().load_machine_step()
			player.give_upgrade.connect(_next_tutorial_step)
		9:
			print("WOOT")
			$Timer.text = "Task: Select an upgrade."
			player.give_upgrade.disconnect(_next_tutorial_step)
			player.upgrade_added.connect(_next_tutorial_step)
		10:
			$Timer.text = "Task: Survive the tornado!"
			EventMan.spawn_event(EventMan.Events.TORNADO, _get_level(), 1)
			player.upgrade_added.disconnect(_next_tutorial_step)


func _process(delta: float) -> void:
	if not player:
		return
	_update_stat_bars()

	if Globals.level is Level and not get_tree().paused:
		Gamestats.level_time += delta

	if not tutorial_mode:
		var minutes = Gamestats.level_time / 60
		var seconds = fmod(Gamestats.level_time, 60)
		var milliseconds = fmod(Gamestats.level_time, 1) * 100
		var time_string = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
		$Timer.text = time_string

	# Update temperature displays
	if player.state.temp.val <= 10:
		$FreezeOverlay.modulate.a = (10 - player.state.temp.val) / 10
	else:
		$FreezeOverlay.modulate.a = 0

	#$VBoxContainer/temp.value = player.state.temp.val * 100 / player.state.temp.val_max
	
