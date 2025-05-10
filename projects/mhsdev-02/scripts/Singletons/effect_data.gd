extends Node

## List of all effects
enum EffectTypes {
	WEATHER_COLD,
	WEATHER_WARM,
	CAMPFIRE,
	COOL,
	FIRE,
	BURNING
}

## Status effect class for entities
class Effect:
	
	signal removed
	
	var type:EffectTypes
	var duration:float
	var strength:float
	var target:Entity
	var particle_obj:GPUParticles2D
	
	func _init(effect_type:EffectTypes, effect_duration:float, effect_strength:float, effect_target:Entity):
		self.type = effect_type
		self.duration = effect_duration
		self.strength = effect_strength
		self.target = effect_target
		self.particle_obj = null
		
		self.visual_init()

	func apply(delta):
		match self.type:
			EffectTypes.WEATHER_COLD:
				if "temp" in self.target.state:
					self.target.state.temp.val -= self.strength * delta

			EffectTypes.BURNING:
				self.target._update_health(self.target.health - self.strength * delta)

	func visual_init(): ## TODO Apply visual effect on entity
		if not self.particle_obj:
			match self.type:
				EffectTypes.BURNING:
					self.particle_obj = load("res://scenes/Effects/burning.tscn").instantiate()
					
					var sprite = self.target.sprite
					var width = self.target.get_sprite_texture().get_width() * sprite.scale.x * 0.5
					var height = self.target.get_sprite_texture().get_height() * sprite.scale.y * 0.5
					
					self.particle_obj.amount = width * 2

					self.particle_obj.process_material.emission_box_extents = Vector3(width, height, 10)
					self.target.add_child(self.particle_obj)

	func return_icon(): ## TODO Get display icon and visualize
		pass
	
	func remove():
		if self.particle_obj:
			self.particle_obj.queue_free()
		
		self.removed.emit()
