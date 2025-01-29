extends Node

## List of all effects
enum EffectTypes {
	WEATHER_COLD,
	WEATHER_WARM,
	CAMPFIRE,
	COOL,
	FIRE
}

## Status effect class for entities
class Effect:
	var type:EffectTypes
	var duration:float
	var strength:float
	var target:Entity
	
	func _init(effect_type:EffectTypes, effect_duration:float, effect_strength:float, effect_target:Entity):
		self.type = effect_type
		self.duration = effect_duration
		self.strength = effect_strength
		self.target = effect_target

	func apply(delta):
		var is_player = self.target is Player
		match self.type:
			0: # WEATHER_COLD
				if is_player:
					self.target.temp -= self.strength * delta
			1: # WEATHER_WARM
				if is_player:
					self.target.temp += 1 * delta

		# Clamp stats
		if is_player:
			self.target.temp = clamp(self.target.temp, 0, 100)
			self.target.hunger = clamp(self.target.temp, 0, 100)
			self.target.temp = clamp(self.target.temp, 0, 100)

	func visual():
		pass

	func return_icon(): ## TODO Get display icon and visualize
		pass
