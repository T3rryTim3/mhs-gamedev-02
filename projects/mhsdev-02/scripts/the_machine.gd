extends StaticBody2D
class_name Machine

signal fully_powered

enum CostGroups {
	FIELD,
	TUTORIAL,
	TUNDRA,
	DESERT
}

## Cost display object
@onready var cost_item = preload("res://scenes/UI/cost_item.tscn")

## Lightning strike
@onready var strike_scn = preload("res://scenes/Events/LightningStrike.tscn")

## Fireball
@onready var fireball_scn = preload("res://scenes/Events/fireball.tscn")

## Collector
@onready var collector = $Collector

## Object containing the cost display objects
@onready var cost_container:VBoxContainer = $VBoxContainer

## The selected costs for the machine
@export var selected_costs:CostGroups

## The costs after being loaded from selected_costs
var costs:Array

## Currently spent resources
var spent_resources:Dictionary[ItemData.ItemTypes, int]

## Used for animation
var scale_val:float = 1.0

## The cost for the next station tier
var cost:Dictionary[ItemData.ItemTypes, int]

## The current index in the 'selected_costs' array
var cost_index:int = 0

## If the game is currently ending
var ending:bool = false

## Current progress in the game ending
var end_prog:float = 0

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_6:
					_ending()

func _load_costs(): ## Loads the costs from 'selected_costs'
	match selected_costs:
		CostGroups.FIELD:
			costs = [
				[5,{ItemData.ItemTypes.WHEAT: 1, ItemData.ItemTypes.WOOD: 2}],
				[8,{ItemData.ItemTypes.WHEAT: 1, ItemData.ItemTypes.WOOD: 2}],
				[12,{ItemData.ItemTypes.WHEAT: 1, ItemData.ItemTypes.WOOD: 2, ItemData.ItemTypes.ROCK: 2}],
				[14,{ItemData.ItemTypes.BREAD: 3, ItemData.ItemTypes.WOOD: 0.8, ItemData.ItemTypes.ROCK: 1}],
				[20,{ItemData.ItemTypes.BREAD: 3, ItemData.ItemTypes.WOOD: 0.8, ItemData.ItemTypes.ROCK: 1}]
			]
		CostGroups.TUNDRA:
			costs = [
				[5,{ItemData.ItemTypes.ROCK: 1, ItemData.ItemTypes.WATER: 2, ItemData.ItemTypes.WHEAT_SEEDS: 2}],
				[8,{ItemData.ItemTypes.WHEAT: 1, ItemData.ItemTypes.WOOD: 2, ItemData.ItemTypes.ROCK: 1}],
				[12,{ItemData.ItemTypes.BREAD: 3, ItemData.ItemTypes.WATER_CLEAN: 3, ItemData.ItemTypes.ROCK: 1}],
				[14,{ItemData.ItemTypes.BREAD: 3, ItemData.ItemTypes.WOOD: 2, ItemData.ItemTypes.WATER_CLEAN: 3}],
				[20,{ItemData.ItemTypes.BREAD: 3, ItemData.ItemTypes.WOOD: 2, ItemData.ItemTypes.ROCK: 1, ItemData.ItemTypes.WATER_CLEAN: 3}]
			]
		CostGroups.DESERT:
			costs = [
				[5,{ItemData.ItemTypes.WHEAT: 1, ItemData.ItemTypes.WATER: 2}],
				[8,{ItemData.ItemTypes.WHEAT: 0.8, ItemData.ItemTypes.WOOD: 1.5, ItemData.ItemTypes.ROCK: 1}],
				[12,{ItemData.ItemTypes.BREAD: 2.5, ItemData.ItemTypes.WATER_CLEAN: 2.5, ItemData.ItemTypes.ROCK: 0.8}],
				[14,{ItemData.ItemTypes.BREAD: 3, ItemData.ItemTypes.WOOD: 2, ItemData.ItemTypes.WATER_CLEAN: 3}],
				[20,{ItemData.ItemTypes.BREAD: 3, ItemData.ItemTypes.WOOD: 2, ItemData.ItemTypes.ROCK: 1, ItemData.ItemTypes.WATER_CLEAN: 3}]
			]
		CostGroups.TUTORIAL:
			costs = [
				[3,{ItemData.ItemTypes.BREAD: 2, ItemData.ItemTypes.WATER: 0.5}]
			]

func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

func _next_cost(): ## Selects the next cost in 'costs'
	$Label.text = str(cost_index) + "/" + str(len(costs))
	if cost_index >= len(costs): # If there are no more costs
		cost = {}
		#_update_cost()
		return
	select_cost(costs[cost_index][0], costs[cost_index][1])
	cost_index += 1

func _ready():
	cost = {
		ItemData.ItemTypes.WOOD: 1
	}
	_load_costs()
	_next_cost()
	_display_cost()

func _process(delta: float) -> void:
	if get_viewport().get_camera_2d().global_position.y + 24 <global_position.y + $Sprite2D.texture.get_height()/2.0:
		z_index = 5
	else:
		z_index = -1

	if ending:
		_end_process(delta)
		return

	$Sprite2D.scale.y = scale_val
	scale_val = clampf(scale_val - 1 * delta, 1, 2)

	var player:Player = _get_level().player
	var sizex = $Sprite2D.texture.get_size().x
	var sizey = $Sprite2D.texture.get_size().y
	var success = false

	var item_id = -1
	if len(player.collector.current_resources) > 0:
		item_id = player.collector.get_topmost_item().id

	# Check if the hovered item can be spent and is overlapping the blueprint
	if item_id != -1 and cost.has(item_id) and spent_resources[item_id] < cost[item_id] and player.current_item_display:
		var pos = player.current_item_display.global_position
		if (pos.x > global_position.x - sizex/2) and (pos.x < global_position.x + sizex/2):
			if (pos.y > global_position.y - sizey/2) and (pos.y < global_position.y + sizey/2):
				scale = Vector2(1.1,1.1)
				success = true
				if not (self in player.hovered_blueprints):
					player.hovered_blueprints.append(self)
	if not success: # Reset the size if not applicable
		if (self in player.hovered_blueprints):
			player.hovered_blueprints.erase(self)
		scale = Vector2(1,1)

## Set the cost of the machine based upon the price given. 
## 'Items' is the dict of items that can be chosen (Item, Price).
func select_cost(price:float, items):
	cost = {}
	collector.clear_items()
	while price > 0:
		# Stop if there are no more possible items
		if len(items) == 0:
			break

		var selection = items.keys()[randi_range(0,len(items)-1)]

		# Don't select if too expensive
		if price - items[selection] < 0:
			items.erase(selection)
			continue

		# Add to cost
		price -= items[selection]
		if cost.has(selection):
			cost[selection] += 1
		else:
			cost[selection] = 1

	for k in cost:
		spent_resources[k] = 0

func _display_cost():
	for child in cost_container.get_children():
		child.queue_free()
	for k in cost:
		var item = cost_item.instantiate()
		cost_container.add_child(item)
		item.label.text = "0/" + str(cost[k])
		item.texture_rect.texture = load(ItemData.get_item_data(k)["img_path"])
		item.id = k

func _update_cost():
	for k in cost_container.get_children():
		if not (k.id in cost):
			_display_cost()
			return
		k.label.text = str(spent_resources[k.id]) + "/" + str(cost[k.id])

func _check_completion():
	for k in cost:
		if cost[k] == spent_resources[k]:
			continue
		return false
	return true

func _ending() -> void: ## Ends the game
	ending = true
	var player:Player = Globals.level.player
	player.max_health *= 2
	player.health = player.max_health

func _passed(target:float,a:float,b:float) -> bool: ## Returns true if a passed target, using b as its previous value
	return (a >= target) and b < target

func _strike_lightning(str:float,pos:Vector2,time:float=1.0, vol:float=1.0):
	var strike = strike_scn.instantiate()
	strike.data = EventMan.EventData.new("","",0,str)
	_get_level().add_child(strike)
	strike.warning_time = time
	strike.global_position = pos
	strike.strike_sound.volume_linear = vol
	strike.spark_sound.volume_linear = vol

func _lightning_circle(str:float,pos:Vector2,count:int,dist:float=200, time:float=1.0):
	for x in range(count):
		if x == 0:
			_strike_lightning(2,global_position + Vector2(dist*cos((2*PI)*x/count),dist*sin((2*PI)*x/count)), time, 1)
		else:
			_strike_lightning(2,global_position + Vector2(dist*cos((2*PI)*x/count),dist*sin((2*PI)*x/count)), time, 0.01)

func _fireball(dir:Vector2, damage:float, stren:float, pos:Vector2):
	var ball:CharacterBody2D = fireball_scn.instantiate()
	ball.rotation = dir.angle()
	ball.velocity = dir * EventMan.scale_val(stren) * 100
	ball.global_position = pos
	ball.scale = Vector2(3,3)
	ball.damage = damage
	ball.push_strength = EventMan.scale_val(stren) * 100
	_get_level().map.add_child(ball)

func _end_process(delta) -> void: ## Called during the end of the game each frame
	var prev = end_prog
	var level:Level = Globals.level
	var player:Player = Globals.level.player
	#var stren = level.strength
	var stren = 30

	if not player:
		return

	end_prog += delta

	#TODO: Remove when done
	Globals.current_level = Globals.main.Scenes.LEVEL_FIELD

	player.state.hunger.val = lerpf(player.state.hunger.val, player.state.hunger.val_max, delta*2)
	player.state.thirst.val = lerpf(player.state.thirst.val, player.state.thirst.val_max, delta*2)
	player.state.temp.val = lerpf(player.state.temp.val, 50, delta*2)
	#
	player.state.stamina.val = 100

	match Globals.current_level:
		Globals.main.Scenes.LEVEL_FIELD:

			if end_prog < 10:
				var shake:float = min(0.3,sin((end_prog/10)*(PI/10)))
				if player.camera.trauma < shake:
					player.camera.trauma = shake

				if _passed(3,end_prog,prev):
					_lightning_circle(1, global_position, 20, 200)
				if _passed(4,end_prog,prev):
					_lightning_circle(1, global_position, 15, 150)
				if _passed(5,end_prog,prev):
					_lightning_circle(1, global_position, 10, 100)
				if _passed(7,end_prog,prev):
					_strike_lightning(100, global_position, 3, 0)
					_lightning_circle(0.5, global_position, 20, 150, 3)

			if _passed(10,end_prog,prev):
				hide()
				EventMan.spawn_event(EventMan.Events.VOLCANO, level, stren)
				EventMan.spawn_event(EventMan.Events.VOLCANO, level, stren)
			if _passed(15, end_prog,prev):
				EventMan.spawn_event(EventMan.Events.STORM, level, stren)
			if _passed(25, end_prog,prev):
				for x in range(4):
					EventMan.spawn_event(EventMan.Events.TORNADO, level, stren/4)
			if _passed(30, end_prog,prev):
				EventMan.spawn_event(EventMan.Events.EARTHQUAKE, level, stren)
			if _passed(35, end_prog,prev):
				_lightning_circle(1, player.global_position, 8, 60)
			if _passed(40,end_prog,prev):
				for x in range(4):
					EventMan.spawn_event(EventMan.Events.VOLCANO, level, stren/2)
			if _passed(50, end_prog,prev):
				_lightning_circle(1, global_position, 10, 100, 2)
				_lightning_circle(1, global_position, 10, 200)
			print(end_prog)
			if end_prog > 55 and end_prog < 65:
				if fmod(end_prog, 2) < fmod(prev, 2):
					var ang = randf_range(0,2*PI)
					for x in range(20):
						var dir = Vector2(cos((2*PI*x)/20 + ang), sin(2*PI*x/20 + ang))
						_fireball(dir, 2, stren, global_position)
				if fmod(end_prog, 5) < fmod(prev, 5):
					var offset = randi_range(-100,100)
					_lightning_circle(1, global_position, 10, 100 + offset, 3)
					_lightning_circle(1, global_position, 20, 200 + offset, 5)
					_lightning_circle(1, global_position, 30, 400 + offset, 7)
					_lightning_circle(1, global_position, 40, 800 + offset, 9)
			if end_prog > 65:
				pass
			#if end_prog > 100 and end_prog < 105:
				#if fmod(end_prog, 0.1) < fmod(prev, 0.1):
					#var ang = randf_range(0,2*PI)
					#var dir = Vector2(cos(ang), sin(ang))
					#_fireball(dir, 2, stren, global_position)
				
	
func _complete() -> void:
	var level:Level = _get_level()
	level.player.health = level.player.max_health
	level.machine_powered.emit()
	level.player.give_upgrade.emit()
	_next_cost()
	if cost == {}:
		_ending()
		fully_powered.emit()
	_display_cost()
	_update_cost()

func _on_collector_item_given(item) -> void:
	for k in cost.keys():
		if item.id == k and cost[k] - spent_resources[k] > 0:
			collector.add_item(item)
			collector.delete_item()
			spent_resources[k] += 1
	scale_val = 1.2
	
	if _check_completion():
		_complete()
	else:
		_update_cost()
