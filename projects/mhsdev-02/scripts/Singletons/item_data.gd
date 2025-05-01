extends Node

enum ItemTypes
{
	WOOD,
	WHEAT,
	BREAD,
	WATER,
	WATER_CLEAN,
	ROCK,
	WHEAT_SEEDS,
	APPLE
}

func get_item_data(id:ItemTypes) -> Dictionary:
	
	var img_path = "res://images/items/wheat.png" # Default texture
	var decay_rate = 0.05
	var health = 1
	var use_time = 0
	var pickup_sound = "res://Audio/SFX/Items/Wheat.wav"
	var effect_immunities:Array[EffectData.EffectTypes]
	
	match id:
		ItemTypes.WOOD:
			health = 11
			decay_rate = 0
			img_path = "res://images/items/wood.png"
			pickup_sound = "res://Audio/SFX/Items/wood.wav"
		ItemTypes.WHEAT:
			health = 3
			decay_rate = 0.12
			img_path = "res://images/items/wheat.png"
			pickup_sound = "res://Audio/SFX/Items/wheat.wav"
		ItemTypes.BREAD:
			health = 6
			decay_rate = 0.1
			use_time = 0.5
			img_path = "res://images/items/bread.png"
			pickup_sound = "res://Audio/SFX/rock.wav"
		ItemTypes.WATER:
			health = 1
			decay_rate = 0.0
			use_time = 0.5
			img_path = "res://images/items/dirty_water.png"
			effect_immunities = [
				EffectData.EffectTypes.BURNING
			]
		ItemTypes.WATER_CLEAN:
			health = 1
			decay_rate = 0.0
			use_time = 0.5
			img_path = "res://images/items/water.png"
			effect_immunities = [
				EffectData.EffectTypes.BURNING
			]
		ItemTypes.ROCK:
			health = 17
			decay_rate = 0
			img_path = "res://images/items/rock.png"
			pickup_sound = "res://Audio/SFX/Items/stone.wav"
			effect_immunities = [
				EffectData.EffectTypes.BURNING
			]
		ItemTypes.WHEAT_SEEDS:
			health = 3
			decay_rate = 0
			img_path = "res://images/items/Wheat Seeds Bag.png"
		ItemTypes.APPLE:
			health = 8
			decay_rate = 0.1
			img_path = "res://images/items/Wheat Seeds.png"
	return {
		"health": health,
		"decay_rate": decay_rate,
		"img_path": img_path,
		"use_time": use_time,
		"id": id,
		"pickup_sound": pickup_sound,
		"effect_immunities": effect_immunities
	}

func use_item(item:Item, player:Player, delta:float):
	if item.using == false:
		item.item_usage_progress = 0
		item.using = true
	
	item.item_usage_progress += delta

	# If item fully used
	if item.item_usage_progress >= item.item_usage_max:
		player.emit_signal("item_used", item)
		match item.id:
			ItemTypes.WOOD:
				pass
			ItemTypes.WHEAT:
				pass
			ItemTypes.BREAD:
				player.state.hunger.val += 20
				item.queue_free()
			ItemTypes.WATER:
				player.state.thirst.val += 10
				item.queue_free()
			ItemTypes.WATER_CLEAN:
				player.state.thirst.val += 20
				item.queue_free()
			ItemTypes.APPLE:
				player.state.thirst.val += 8
				player.state.hunger.val += 8
				item.queue_free()
			ItemTypes.ROCK:
				pass
		item.using = false
